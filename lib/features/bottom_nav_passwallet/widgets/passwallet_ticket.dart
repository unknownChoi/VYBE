import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';
import 'package:vybe/features/bottom_nav_passwallet/utils/passwallet_formatters.dart';

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
    final upper = value.toUpperCase();
    return upper;
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

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    required this.label,
    required this.bgColor,
    required this.onTap,
  });

  final String label;
  final Color bgColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
//====================버튼====================

//====================티켓 도형====================

class PasswalletTicket extends StatefulWidget {
  // 공통 + 상태별 선택 필드 (내부 보관용)
  final PassStatus status;

  final String clubName;
  final String scheduledDate;
  final String scheduledTime;
  final int count;

  // 상태별 선택
  final int? currentNum; // waiting, entering 전용
  final String? reservatiaonTable; // reservation 전용

  // 내부 공용 생성자
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

  // status == entering:
  // clubName, scheduledDate, scheduledTime, count, currentNum
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

  // status == entered:
  // clubName, scheduledDate, scheduledTime, count
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

  // status == reservation:
  // clubName, scheduledDate, scheduledTime, count, reservatiaonTable
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

  // status == waiting:
  // clubName, scheduledDate, scheduledTime, count, currentNum
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
  static const int _kQrSeconds = 10; // TODO: 릴리스 시 60으로 변경

  Timer? _qrDisplayTimer; // 1분: QR 보여주기 시간
  Timer? _entryWindowTimer; // 15분: 입장시간

  int _qrDisplaySeconds = _kQrSeconds; // 01:00 → 00:00
  int _entryWindowSeconds = 15 * 60; // 15:00 → 00:00

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

  // 상태 전환 시 타이머 제어
  void _handleStatus(PassStatus s) {
    if (s == PassStatus.entering) {
      // 입장 중 전환 시 두 타이머 시작/리셋
      _qrDisplaySeconds = 60;
      _entryWindowSeconds = 15 * 60;
      _startQrDisplayTimer();
      _startEntryWindowTimer();
    } else {
      // 그 외에는 모두 정지 및 표기 초기화(원하면 초기화 생략 가능)
      _stopAllTimers();
      _qrDisplaySeconds = 60;
      _entryWindowSeconds = 15 * 60;
      setState(() {});
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

    return Center(
      child: Column(
        children: [
          // 상단 컨테이너
          SizedBox(height: 24.h),
          Container(
            width: 345.w,
            height: 98.h,
            decoration: BoxDecoration(
              color: AppColors.appPurpleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.clubName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.08,
                    letterSpacing: (-0.60).w,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.scheduledDate,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFECECEC),
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14,
                        letterSpacing: (-0.70).w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/common/dot.svg',
                      color: const Color(0xFFECECEC),
                      width: 2.w,
                      height: 2.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      widget.scheduledTime,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFECECEC),
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14,
                        letterSpacing: (-0.70).w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/common/dot.svg',
                      color: const Color(0xFFECECEC),
                      width: 2.w,
                      height: 2.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _statusLabel(status),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFECECEC),
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14,
                        letterSpacing: (-0.70).w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 본문 컨테이너
          Container(
            width: 345.w,
            height: 200.h,
            color: const Color(0xFF2F2F33),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    if (status == PassStatus.waiting) ...[
                      // 대기중
                      Text(
                        '현재 대기 번호',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.12,
                          letterSpacing: (-0.80).w,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "${widget.currentNum}번",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFB5FF60),
                          fontSize: 44.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                          letterSpacing: (-1.10).w,
                        ),
                      ),
                      SizedBox(height: 18.h),
                    ] else if (status == PassStatus.entered) ...[
                      // 입장 완료
                      Text(
                        '입장완료',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFB5FF60),
                          fontSize: 32.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                          letterSpacing: (-1.10).w,
                        ),
                      ),
                      SizedBox(height: 18.h),
                    ] else if (status == PassStatus.entering) ...[
                      // 입장중
                      Text(
                        '현재 대기 번호',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.12,
                          letterSpacing: (-0.80).w,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '입장',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFB5FF60),
                          fontSize: 44.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                          letterSpacing: (-1.10).w,
                        ),
                      ),
                      SizedBox(height: 18.h),
                    ] else if (status == PassStatus.reservation) ...[
                      // 예약
                      Text(
                        '예약 상태',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.12,
                          letterSpacing: (-0.80).w,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '예약완료',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFB5FF60),
                          fontSize: 28.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                          letterSpacing: (-1.10).w,
                        ),
                      ),
                      SizedBox(height: 18.h),
                    ],
                  ],
                ),

                if (status == PassStatus.entered) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 남은 시간
                      SizedBox(
                        width: 118.w,
                        child: Column(
                          children: [
                            Text(
                              '대기 시간',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFECECEC),
                                fontSize: 14.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.14,
                                letterSpacing: (-0.70).w,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              status == PassStatus.entering
                                  ? _entryTimeText
                                  : "-", // '09:21' -> _timeText
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFECECEC),
                                fontSize: 20.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.10,
                                letterSpacing: (-0.50).w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 25.w),
                      Container(
                        width: 1.5.w,
                        height: 40.h,
                        color: const Color(0xFF707071),
                      ),
                      SizedBox(width: 25.w),

                      // 인원
                      SizedBox(
                        width: 118.w,
                        child: Column(
                          children: [
                            Text(
                              '인원',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFECECEC),
                                fontSize: 14.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.14,
                                letterSpacing: (-0.70).w,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              '${widget.count}명',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFFECECEC),
                                fontSize: 20.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.10,
                                letterSpacing: (-0.50).w,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    width: 286.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Color(0xFF535355),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Center(
                      child: Text(
                        "후기 작성하러 가기",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white /* White */,
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else if (status == PassStatus.reservation) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 남은 시간
                      Column(
                        children: [
                          Text(
                            '좌석 정보',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: (-0.70).w,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            widget.reservatiaonTable!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: (-0.50).w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.w),
                      Container(
                        width: 1.5.w,
                        height: 40.h,
                        color: const Color(0xFF707071),
                      ),
                      SizedBox(width: 25.w),

                      // 남은 거리
                      Column(
                        children: [
                          Text(
                            '결제 정보',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: (-0.70).w,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '완료',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: (-0.50).w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.w),
                      Container(
                        width: 1.5.w,
                        height: 40.h,
                        color: const Color(0xFF707071),
                      ),
                      SizedBox(width: 25.w),

                      // 인원
                      Column(
                        children: [
                          Text(
                            '인원',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: (-0.70).w,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '${widget.count}명',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: (-0.50).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 남은 시간
                      Column(
                        children: [
                          Text(
                            '남은 시간',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: (-0.70).w,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            status == PassStatus.entering
                                ? _entryTimeText
                                : "-", // '09:21' -> _timeText
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: (-0.50).w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.w),
                      Container(
                        width: 1.5.w,
                        height: 40.h,
                        color: const Color(0xFF707071),
                      ),
                      SizedBox(width: 25.w),

                      // 남은 거리
                      Column(
                        children: [
                          Text(
                            '남은 거리',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: (-0.70).w,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '999m',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: (-0.50).w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.w),
                      Container(
                        width: 1.5.w,
                        height: 40.h,
                        color: const Color(0xFF707071),
                      ),
                      SizedBox(width: 25.w),

                      // 인원
                      Column(
                        children: [
                          Text(
                            '인원',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: (-0.70).w,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            '${widget.count}명',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC),
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: (-0.50).w,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 4.h),

          // 티켓(QR 영역)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 345.w,
                height: 227.h,
                color: const Color(0xFF2F2F33),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120.w,
                          height: 120.w,
                          color: Colors.white,
                        ),

                        if (status != PassStatus.waiting)
                          Positioned(
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              width: 120.w,
                              height: 120.w,
                              child: Image.asset(
                                'assets/images/bottom_nav_passwallet/test_qr.png',
                                width: 110.w,
                                height: 114.w,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        if (_isQrExpired)
                          Positioned(
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _restartQrTimer();
                              },
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 12,
                                    sigmaY: 12,
                                  ),
                                  child: Container(
                                    width: 120.w,
                                    height: 120.w,
                                    alignment: Alignment.center,
                                    color: const Color(
                                      0xFF2F2F33,
                                    ).withOpacity(0.1),
                                    child: Icon(
                                      size: 50.sp,
                                      Icons.refresh,
                                      color: AppColors.appPurpleColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // 입장 중: 카운트다운 문구
                    if (status == PassStatus.entering ||
                        status == PassStatus.entered)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isQrExpired ? "요청 시간 만료" : '남은 시간',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.14,
                                  letterSpacing: (-0.70).w,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _isQrExpired ? "" : _qrTimeText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFB5FF60),
                                  fontSize: 14.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.14,
                                  letterSpacing: (-0.35).w,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '입장 시 직원에게 QR을 보여주세요.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.11,
                              letterSpacing: (-0.90).w,
                            ),
                          ),
                        ],
                      ),

                    // 입장완료: 완료 문구
                  ],
                ),
              ),

              // 대기중: 흐림 오버레이
              if (status == PassStatus.waiting ||
                  status == PassStatus.reservation)
                Positioned(
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: 345.w,
                    height: 227.h,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          alignment: Alignment.center,
                          color: const Color(0xFF2F2F33).withOpacity(0.6),
                          child: Text(
                            "입장시\nQR이 활성화 됩니다.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: (-0.50).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 하단 천공
              Positioned(
                left: 0,
                right: 0,
                bottom: (-12).w,
                height: 14.h,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double stripH = 14.h;
                    final double cy = stripH / 2;
                    final double margin = 12.w;
                    final double usableW = (constraints.maxWidth - margin * 2)
                        .clamp(0.0, double.infinity);
                    const int count = 12;
                    final double step = (count <= 1)
                        ? 0
                        : usableW / (count - 1);

                    return Stack(
                      clipBehavior: Clip.none,
                      children: List.generate(count, (i) {
                        final double x = margin + step * i;
                        return Positioned(
                          left: x - 12.w,
                          top: cy - 12.w,
                          width: 24.w,
                          height: 24.w,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.appBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
          Spacer(),
          SizedBox(
            width: 345.w,
            child: Builder(
              builder: (context) {
                final specs = _buttonSpecsFor(widget.status, context);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BottomButton(
                      label: specs[0].label,
                      bgColor: specs[0].color,
                      onTap: specs[0].onTap,
                    ),
                    const Spacer(),
                    BottomButton(
                      label: specs[1].label,
                      bgColor: specs[1].color,
                      onTap: specs[1].onTap,
                    ),
                  ],
                );
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

//====================티켓 도형====================
class _BtnSpec {
  final String label;
  final Color color;
  final VoidCallback onTap;
  _BtnSpec({required this.label, required this.color, required this.onTap});
}

List<_BtnSpec> _buttonSpecsFor(PassStatus s, BuildContext context) {
  // 색상은 필요하면 AppColors에 정의해서 교체하세요.
  final Color primary = AppColors.appPurpleColor; // 주요 액션

  final Color danger = const Color(0xFF3A3A3E); // 삭제/취소 등

  switch (s) {
    // 입장 전/입장 중 -> [순서 미루기, 웨이팅 취소하기]
    case PassStatus.waiting:
    case PassStatus.entering:
      return [
        _BtnSpec(
          label: '순서 미루기',
          color: primary,
          onTap: () {
            /* TODO: 순서 미루기 액션 */
          },
        ),
        _BtnSpec(
          label: '웨이팅 취소하기',
          color: danger,
          onTap: () {
            /* TODO: 웨이팅 취소 액션 */
          },
        ),
      ];

    // 입장 완료 -> [음료 주문하기, 입장권 삭제하기]
    case PassStatus.entered:
      return [
        _BtnSpec(
          label: '음료 주문하기',
          color: primary, // 필요시 브랜드 Green 등으로 변경
          onTap: () {
            /* TODO: 주문 화면 이동 */
          },
        ),
        _BtnSpec(
          label: '입장권 삭제하기',
          color: danger,
          onTap: () {
            /* TODO: 삭제 확인 다이얼로그 */
          },
        ),
      ];

    // 예약 완료 -> [예약 취소하기, 예약 변경하기]
    case PassStatus.reservation:
      return [
        _BtnSpec(
          label: '예약 취소하기',
          color: danger,
          onTap: () {
            /* TODO: 취소 플로우 */
          },
        ),
        _BtnSpec(
          label: '예약 변경하기',
          color: primary, // 변경은 보조 톤 권장
          onTap: () {
            /* TODO: 변경 플로우 */
          },
        ),
      ];
  }
}
