import 'dart:async';
import 'dart:ui';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';
import 'package:vybe/core/utils/dialog_launcher.dart';
import 'package:vybe/features/bottom_nav_passwallet/utils/passwallet_formatters.dart';

import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/cancle/cancel_waiting_confirm_dialog.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/postpone/postpone_waiting_success_dialog.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/postpone/postpone_waiting_dialog.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/cancle/cancel_waiting_success_dialog.dart';

// Sections (이전 답변에서 제공한 4개 파일)
import 'package:vybe/features/bottom_nav_passwallet/widgets/ticket/sections/ticket_header.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/ticket/sections/ticket_body.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/ticket/sections/ticket_qr_section.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/ticket/sections/ticket_action_row.dart';

/// 서버 맵 → 티켓 위젯 팩토리
PasswalletTicket ticketFromMap(Map<String, dynamic> data) {
  final PassStatus status = data['status'] as PassStatus;

  final String clubName = (data['clubName'] as String?)?.trim() ?? '-';
  final String rawDate = (data['scheduledDate'] as String?)?.trim() ?? '';
  final String rawTime = (data['scheduledTime'] as String?)?.trim() ?? '';
  final int count = (data['enteredCount'] as int?) ?? 0;

  final String displayDate = formatKoreanDate(rawDate);
  final String displayTime = formatAmPm(rawTime);

  String normTable(String? value) {
    if (value == null || value.isEmpty) return '-';
    return value.toUpperCase();
  }

  switch (status) {
    case PassStatus.entering:
      return PasswalletTicket.entering(
        clubName: clubName,
        scheduledDate: displayDate,
        scheduledTime: displayTime,
        count: count,
      );
    case PassStatus.entered:
      return PasswalletTicket.entered(
        clubName: clubName,
        scheduledDate: displayDate,
        scheduledTime: displayTime,
        count: count,
      );
    case PassStatus.reservation:
      final String reservatiaonTable = normTable(
        data['reservatiaonTable'] as String?,
      );
      return PasswalletTicket.reservation(
        clubName: clubName,
        scheduledDate: displayDate,
        scheduledTime: displayTime,
        count: count,
        reservatiaonTable: reservatiaonTable,
      );
    case PassStatus.waiting:
      final int currentNum = data['currentNum'] as int? ?? 0;
      return PasswalletTicket.waiting(
        clubName: clubName,
        scheduledDate: displayDate,
        scheduledTime: displayTime,
        count: count,
        currentNum: currentNum,
      );
  }
}

/// 메인 티켓 위젯 (조립 역할)
class PasswalletTicket extends StatefulWidget {
  // 공통 + 상태별 선택 필드
  final PassStatus status;

  final String clubName;
  final String scheduledDate;
  final String scheduledTime;
  final int count;

  // 상태별 선택
  final int? currentNum; // waiting 전용
  final String? reservatiaonTable; // reservation 전용

  const PasswalletTicket._internal({
    super.key,
    required this.status,
    required this.clubName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.count,
    this.currentNum,
    this.reservatiaonTable,
  });

  // --- 상태별 생성자 ---
  factory PasswalletTicket.entering({
    Key? key,
    required String clubName,
    required String scheduledDate,
    required String scheduledTime,
    required int count,
  }) {
    return PasswalletTicket._internal(
      key: key,
      status: PassStatus.entering,
      clubName: clubName,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      count: count,
    );
  }

  factory PasswalletTicket.entered({
    Key? key,
    required String clubName,
    required String scheduledDate,
    required String scheduledTime,
    required int count,
  }) {
    return PasswalletTicket._internal(
      key: key,
      status: PassStatus.entered,
      clubName: clubName,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      count: count,
    );
  }

  factory PasswalletTicket.reservation({
    Key? key,
    required String clubName,
    required String scheduledDate,
    required String scheduledTime,
    required int count,
    required String reservatiaonTable,
  }) {
    return PasswalletTicket._internal(
      key: key,
      status: PassStatus.reservation,
      clubName: clubName,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      count: count,
      reservatiaonTable: reservatiaonTable,
    );
  }

  factory PasswalletTicket.waiting({
    Key? key,
    required String clubName,
    required String scheduledDate,
    required String scheduledTime,
    required int count,
    required int currentNum,
  }) {
    return PasswalletTicket._internal(
      key: key,
      status: PassStatus.waiting,
      clubName: clubName,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      count: count,
      currentNum: currentNum,
    );
  }

  @override
  State<PasswalletTicket> createState() => _PasswalletTicketState();
}

class _PasswalletTicketState extends State<PasswalletTicket>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final FirebaseFunctions _funcs = FirebaseFunctions.instanceFor(
    region: 'asia-northeast3',
  );

  String? _qrData;

  Future<void> _refreshQr() async {
    await _fetchQrToken();
    _restartQrTimer();
  }

  // ✅ Cloud Functions: getTicketQrToken 호출
  Future<void> _fetchQrToken() async {
    try {
      if (widget.status != PassStatus.entering &&
          widget.status != PassStatus.entered) {
        // 해당 상태가 아니면 발급 안 함
        return;
      }

      // TODO: 실제 ticketId로 교체하세요.
      // 이 위젯에 ticketId가 없다면, 부모로부터 받아서 보관하거나
      // repository/riverpod/bloc 등에서 읽어오세요.
      const ticketId = 'IsjlB2ybGYpo2RpX3lQA';

      final callable = _funcs.httpsCallable('getTicketQrToken');
      final res = await callable.call({'ticketId': ticketId});
      final map = (res.data as Map);
      setState(() {
        _qrData = (map['qr'] as String?) ?? '';
      });
    } on FirebaseFunctionsException catch (e) {
      // 서버에서 던진 코드들: unauthenticated/window/state 등
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR 발급 실패: ${e.code} ${e.message ?? ""}')),
        );
      }
      setState(() {
        _qrData = null;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('네트워크 오류: $e')));
      }
      setState(() {
        _qrData = null;
      });
    }
  }

  /// QR/입장 타이머 (현재 구조 유지: 다음 단계에서 Controller로 분리 가능)
  static const int _kQrSeconds = 10; // TODO: 릴리스 시 60으로
  Timer? _qrDisplayTimer; // QR 표시 타이머
  Timer? _entryWindowTimer; // 입장 가능 시간 타이머

  int _qrDisplaySeconds = _kQrSeconds;
  int _entryWindowSeconds = 15 * 60;

  bool get _isQrExpired => _qrDisplaySeconds <= 0;

  String get _qrTimeText {
    final m = (_qrDisplaySeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_qrDisplaySeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String get _entryTimeText {
    final m = (_entryWindowSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_entryWindowSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _restartQrTimer() {
    _qrDisplayTimer?.cancel();
    setState(() {
      _qrDisplaySeconds = _kQrSeconds;
    });
    _startQrDisplayTimer();
  }

  void _startQrDisplayTimer() {
    _qrDisplayTimer?.cancel();
    _qrDisplayTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_qrDisplaySeconds <= 0) {
        t.cancel();
        setState(() {});
        return;
      }
      setState(() => _qrDisplaySeconds--);
    });
  }

  void _startEntryWindowTimer() {
    _entryWindowTimer?.cancel();
    _entryWindowTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_entryWindowSeconds <= 0) {
        t.cancel();
        setState(() {});
        return;
      }
      setState(() => _entryWindowSeconds--);
    });
  }

  void _stopAllTimers() {
    _qrDisplayTimer?.cancel();
    _entryWindowTimer?.cancel();
  }

  // 상태 전환 시 타이머 핸들링
  void _handleStatus(PassStatus s) {
    if (s == PassStatus.entering) {
      _qrDisplaySeconds = 60; // 실제 TTL과 맞춰도 OK (예: 30초)
      _entryWindowSeconds = 15 * 60;
      _startQrDisplayTimer();
      _startEntryWindowTimer();
      // ✅ 상태가 entering이면 즉시 발급
      unawaited(_fetchQrToken());
    } else {
      _stopAllTimers();
      _qrDisplaySeconds = 60;
      _entryWindowSeconds = 15 * 60;
      setState(() {
        _qrData = null; // 상태 벗어나면 QR 비움
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _handleStatus(widget.status);
  }

  @override
  void didUpdateWidget(covariant PasswalletTicket oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _handleStatus(widget.status);
    }
  }

  @override
  void dispose() {
    _stopAllTimers();
    super.dispose();
  }

  String _statusLabel(PassStatus s) {
    switch (s) {
      case PassStatus.waiting:
        return '입장 대기 중';
      case PassStatus.entering:
        return '입장 중';
      case PassStatus.entered:
        return '입장완료';
      case PassStatus.reservation:
        return '예약완료';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final status = widget.status;
    final actions = _buildActionSpecs(status, context);

    return Center(
      child: Column(
        children: [
          SizedBox(height: 24.h),
          TicketHeader(
            clubName: widget.clubName,
            scheduledDate: widget.scheduledDate,
            scheduledTime: widget.scheduledTime,
            statusLabel: _statusLabel(status),
          ),
          TicketBody(
            status: status,
            count: widget.count,
            currentNum: widget.currentNum,
            reservationTable: widget.reservatiaonTable,
            entryTimeText: _entryTimeText,
          ),
          SizedBox(height: 4.h),
          TicketQrSection(
            status: status,
            isQrExpired: _isQrExpired,
            qrTimeText: _qrTimeText,
            onRefresh: _refreshQr,
            qrData: _qrData ?? '',
          ),
          const Spacer(),
          TicketActionRow(specs: actions),
          const Spacer(),
        ],
      ),
    );
  }

  /// 상태별 액션 스펙 구성
  List<TicketActionSpec> _buildActionSpecs(PassStatus s, BuildContext context) {
    final Color primary = AppColors.appPurpleColor;
    final Color danger = const Color(0xFF3A3A3E);

    switch (s) {
      case PassStatus.waiting:
      case PassStatus.entering:
        return [
          TicketActionSpec(
            label: '순서 미루기',
            color: primary,
            onTap: () {
              unawaited(_handlePostponeTap(context));
            },
          ),
          TicketActionSpec(
            label: '웨이팅 취소하기',
            color: danger,
            onTap: () {
              unawaited(_handleCancelTap(context));
            },
          ),
        ];
      case PassStatus.entered:
        return [
          TicketActionSpec(
            label: '음료 주문하기',
            color: primary,
            onTap: () {
              /* TODO: 주문 화면 이동 */
            },
          ),
          TicketActionSpec(
            label: '입장권 삭제하기',
            color: danger,
            onTap: () {
              /* TODO: 삭제 확인 다이얼로그 */
            },
          ),
        ];
      case PassStatus.reservation:
        return [
          TicketActionSpec(
            label: '예약 취소하기',
            color: danger,
            onTap: () {
              /* TODO: 취소 플로우 */
            },
          ),
          TicketActionSpec(
            label: '예약 변경하기',
            color: primary,
            onTap: () {
              /* TODO: 변경 플로우 */
            },
          ),
        ];
    }
  }

  // === 액션 핸들러 ===

  Future<void> _handleCancelTap(BuildContext context) async {
    final confirmed = await showCancelWaitingConfirmDialog(context);
    if (confirmed != true || !context.mounted) return;

    // TODO: 실제 취소 API/상태 업데이트 로직 수행
    // ex) await repo.cancelWaiting(ticketId);

    if (!context.mounted) return;
    await showCancelWaitingSuccessDialog(context);

    // (선택) 성공 이후 상태 갱신/토스트/리스트 리프레시 등
    // setState(() { ... });
  }

  Future<void> _handlePostponeTap(BuildContext context) async {
    // 필요 시 파라미터 있는 다이얼로그로 교체
    final movedTeams = await showPostponeWaitingDialog(
      context,
      initial: 1,
      min: 1,
      max: 20,
    );

    if (movedTeams == null || !context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _PostponeResultDialog(movedTeams: movedTeams),
    );
  }
}

/// 미루기 성공 다이얼로그 렌더용
class _PostponeResultDialog extends StatelessWidget {
  const _PostponeResultDialog({required this.movedTeams});
  final int movedTeams;

  @override
  Widget build(BuildContext context) {
    return Center(child: PostponeWaitingSuccessDialog(movedTeams: movedTeams));
  }
}

Future<int?> showPostponeWaitingDialog(
  BuildContext context, {
  int initial = 1,
  int min = 1,
  int? max = 20,
}) {
  // 현재 다이얼로그는 기본 설정만 사용하므로 전달값은 향후 확장용으로 남겨둡니다.
  return showScaleBlurDialog<int?>(context, const PostponeWaitingDialog());
}

Future<bool?> showCancelWaitingConfirmDialog(BuildContext context) {
  return showScaleBlurDialog<bool?>(
    context,
    const CancelWaitingConfirmDialog(),
  );
}

Future<void> showCancelWaitingSuccessDialog(BuildContext context) {
  return showScaleBlurDialog<void>(context, const CancelWaitingSuccessDialog());
}
