/* eslint-disable max-len */

import * as admin from "firebase-admin";
import * as crypto from "crypto";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2/options";
import {defineSecret} from "firebase-functions/params";

admin.initializeApp();

const VYBE_SECRET = defineSecret("VYBE_SECRET");
setGlobalOptions({
  region: "asia-northeast3",
  secrets: [VYBE_SECRET],
});

const b64url = (b: Buffer) =>
  b
    .toString("base64")
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");

/**
 * v|ticketId|uid|clubId|exp|nonce 를 비밀키로 HMAC-SHA256 후
 * base64url(96bit 부분)로 서명 문자열을 만든다.
 * @param {string[]} parts - 순서 고정: ["v=1", ticketId, uid, clubId, exp, nonce]
 * @return {string} 96비트(base64url) 서명 문자열
 */
const sign = (parts: string[]) => {
  const secret = VYBE_SECRET.value();
  if (!secret) {
    throw new HttpsError("internal", "secret-missing");
  }
  const mac = crypto.createHmac("sha256", secret);
  mac.update(parts.join("|"));
  return b64url(mac.digest().subarray(0, 12));
};

interface TicketDoc {
  uid: string;
  clubId: string;
  ttlDeleteAt?: admin.firestore.Timestamp;
  activeNonce?: string;
}

// UTC 기준 fromMs에서 "다음 09:00(KST)"의 UTC epoch ms 반환
const KST_OFFSET_MS = 9 * 60 * 60 * 1000;

/**
 * 기준 시각(UTC ms)로부터 KST 기준 다음 closeHour:00의 UTC ms를 구한다.
    * @param {number} fromMs - 기준 시간(UTC ms)
* @param {number} [closeHour=9] - KST 마감 시(hour)
 * @return {number} UTC epoch milliseconds
 */
function nextCloseAtKSTMs(fromMs: number, closeHour = 9): number {
  const kstMs = fromMs + KST_OFFSET_MS;
  const d = new Date(kstMs);
  const y = d.getUTCFullYear();
  const m = d.getUTCMonth();
  const day = d.getUTCDate();
  const h = d.getUTCHours();
  const nextDay = h < closeHour ? day : day + 1;
  const boundaryKST = Date.UTC(y, m, nextDay, closeHour, 0, 0);
  return boundaryKST - KST_OFFSET_MS;
}

/**
 * QR(1분) 생성 + ttlDeleteAt(다음 09:00 KST) 계산/저장
 * 입력: { ticketId }
 * 반환: { qr, ttlDeleteAtMs, ttlIso }
 */
export const getTicketQrToken = onCall(async (req) => {
  const {ticketId} = (req.data || {}) as { ticketId?: string };
  if (!ticketId) {
    throw new HttpsError("invalid-argument", "ticketId-missing");
  }

  const ref = admin.firestore().doc(`tickets/${ticketId}`);
  const snap = await ref.get();
  if (!snap.exists) {
    throw new HttpsError("not-found", "ticket");
  }

  const t = snap.data() as TicketDoc;

  // ttlDeleteAt 없으면 지금 기준으로 계산해 저장
  const now = Date.now();
  let ttlMs = t.ttlDeleteAt?.toMillis?.();
  if (!ttlMs) {
    ttlMs = nextCloseAtKSTMs(now, 9);
    await ref.set(
      {ttlDeleteAt: admin.firestore.Timestamp.fromMillis(ttlMs)},
      {merge: true},
    );
  }

  // QR 1분(60초) 만료
  const exp = Math.floor(now / 1000) + 60;
  const nonce = b64url(crypto.randomBytes(12));

  const parts = [
    "v=1",
    ticketId,
    t.uid,
    t.clubId,
    String(exp),
    nonce,
  ];
  const sig = sign(parts);

  await ref.set({activeNonce: nonce}, {merge: true});

  return {
    qr: `vybe:tk|${parts.join("|")}|${sig}`,
    ttlDeleteAtMs: ttlMs,
    ttlIso: new Date(ttlMs).toISOString(),
  };
});

/**
 * 스태프용(무인증): QR 검증/소모 + 티켓 상태를 redeemed로 업데이트.
 * 입력: { qr: string }  // "vybe:tk|v=1|ticketId|uid|clubId|exp|nonce|sig"
 * 반환: { ok: true, ticketId, uid, clubId, redeemedAt }
 *
 * ⚠️ 주의: 인증을 제거했기 때문에 공개 호출이 가능해집니다.
 * 배포 전, 보안이 필요하면 최소한의 shared secret(예: header나 body key) 체크를 추가하세요.
 */
export const verifyTicket = onCall(async (req) => {
  const qr = (req.data?.qr as string) || "";
  if (!qr.startsWith("vybe:tk|")) {
    throw new HttpsError("invalid-argument", "bad-qr");
  }
  const seg = qr.split("|");
  // ["vybe:tk","v=1",ticketId,uid,clubId,exp,nonce,sig]
  if (seg.length !== 8) {
    throw new HttpsError("invalid-argument", "format");
  }
  const version = seg[1]; // "v=1"
  const ticketId = seg[2];
  const uid = seg[3];
  const clubId = seg[4];
  const expStr = seg[5];
  const nonce = seg[6];
  const sig = seg[7];

  // 1) 만료 검사(60초 + 5초 스큐)
  const exp = parseInt(expStr, 10);
  const nowS = Math.floor(Date.now() / 1000);
  if (!Number.isFinite(exp) || nowS > exp + 5) {
    throw new HttpsError("deadline-exceeded", "expired");
  }

  // 2) 서명 검증
  const expected = sign([version, ticketId, uid, clubId, String(exp), nonce]);
  if (sig !== expected) {
    throw new HttpsError("permission-denied", "bad-signature");
  }

  // 3) Firestore에서 nonce/상태 확인 후 소모 처리(트랜잭션)
  const ref = admin.firestore().doc(`tickets/${ticketId}`);
  const result = await admin.firestore().runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) {
      throw new HttpsError("not-found", "ticket");
    }
    const t = snap.data() as {
      activeNonce?: string;
      status?: string;
      uid?: string;
      clubId?: string;
    };

    // 데이터 무결성 확인(존재하면 일치해야 함)
    if (t.uid && t.uid !== uid) {
      throw new HttpsError("permission-denied", "owner-mismatch");
    }
    if (t.clubId && t.clubId !== clubId) {
      throw new HttpsError("permission-denied", "club-mismatch");
    }

    // 1회용 nonce 확인(재사용 방지)
    if (!t.activeNonce || t.activeNonce !== nonce) {
      throw new HttpsError("failed-precondition", "stale-nonce");
    }

    // 상태 전이: redeemed
    tx.update(ref, {
      status: "redeemed",
      activeNonce: admin.firestore.FieldValue.delete(),
      redeemedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    tx.set(ref.collection("logs").doc(), {
      type: "redeemed",
      by: "staff:unauth", // 인증 없으니 표기만 남김
      at: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {ok: true};
  });

  return {
    ...result,
    ticketId,
    uid,
    clubId,
    redeemedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
});
