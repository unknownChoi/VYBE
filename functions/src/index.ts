import * as admin from "firebase-admin";
import * as crypto from "crypto";
import {onCall, HttpsError} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2/options";
import {defineSecret} from "firebase-functions/params";

admin.initializeApp();

const VYBE_SECRET=defineSecret("VYBE_SECRET");
setGlobalOptions({region: "asia-northeast3", secrets: [VYBE_SECRET]});

const b64url=(b:Buffer)=>
  b
    .toString("base64")
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=+$/, "");

const sign=(parts:string[])=>{
  const secret=VYBE_SECRET.value();
  if (!secret) {
    throw new HttpsError("internal", "secret-missing");
  }
  const mac=crypto.createHmac("sha256", secret);
  mac.update(parts.join("|"));
  return b64url(mac.digest().subarray(0, 12));
};

type TicketStatus=
  | "issued"
  | "presented"
  | "redeemed"
  | "canceled"
  | "expired";

interface TicketDoc{
  uid:string;
  clubId:string;
  status:TicketStatus;
  scheduledAt?:admin.firestore.Timestamp;
  partySize?:number;
  activeNonce?:string;
  redeemedAt?:admin.firestore.Timestamp;
}

export const getTicketQrToken=onCall(async (req)=>{
  const {ticketId}=(req.data||{}) as {ticketId?:string};
  if (!ticketId) {
    throw new HttpsError("invalid-argument", "ticketId-missing");
  }

  const ref=admin.firestore().doc(`tickets/${ticketId}`);
  const snap=await ref.get();
  if (!snap.exists) {
    throw new HttpsError("not-found", "ticket");
  }

  const t=snap.data() as TicketDoc;

  if (!["issued", "presented"].includes(t.status)) {
    throw new HttpsError("failed-precondition", "state");
  }

  const now=Date.now();
  const schedMs=t.scheduledAt?.toMillis?.()??now;
  const inWindow=
    now>=schedMs-5*60_000 &&
    now<=schedMs+15*60_000;
  if (!inWindow) {
    throw new HttpsError("failed-precondition", "window");
  }

  const exp=Math.floor(now/1000)+30;
  const nonce=b64url(crypto.randomBytes(12));
  const parts=[
    "v=1",
    ticketId,
    t.uid,
    t.clubId,
    String(exp),
    nonce,
  ];
  const sig=sign(parts);

  await ref.set({status: "presented", activeNonce: nonce}, {merge: true});
  return {qr: `vybe:tk|${parts.join("|")}|${sig}`};
});
