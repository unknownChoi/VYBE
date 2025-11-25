import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key, required this.reservationData});

  final Map<String, dynamic> reservationData;

  String get _clubName => reservationData['clubName'] as String? ?? '';
  DateTime? get _reservationDate =>
      reservationData['reservationDate'] as DateTime?;
  String get _timeSlot => reservationData['timeSlot'] as String? ?? '';
  String get _tableId => reservationData['tableId']?.toString() ?? '';
  int get _guestCount => (reservationData['guestCount'] as num?)?.toInt() ?? 0;

  String get _formattedDate {
    final date = _reservationDate;
    if (date == null) {
      return '';
    }
    return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final tableText = _tableId.isNotEmpty ? '$_tableId번 테이블' : '';
    final guestText = _guestCount > 0 ? '$_guestCount명' : '';
    final tableAndGuest = [
      if (tableText.isNotEmpty) tableText,
      if (guestText.isNotEmpty) guestText,
    ].join(' · ');
    final dateAndTime = [
      if (_formattedDate.isNotEmpty) _formattedDate,
      if (_timeSlot.isNotEmpty) _timeSlot,
    ].join(' ');

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 24.w + 48.w,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          '결제완료',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.10,
            letterSpacing: -0.50,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                width: 80.w,
                height: 80.w,
                'assets/icons/table_reservation_page/success_icon.svg',
              ),
              SizedBox(height: 60.h),
              Text(
                '테이블 예약이 완료되었습니다!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.08,
                  letterSpacing: -0.60,
                ),
              ),
              SizedBox(height: 24.h),
              if (_clubName.isNotEmpty)
                Text(
                  _clubName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACB) /* Gray400 */,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              if (dateAndTime.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  dateAndTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACB) /* Gray400 */,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              ],
              if (tableAndGuest.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  tableAndGuest,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACB) /* Gray400 */,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              ],
              SizedBox(height: 24.h),

              Stack(
                children: [
                  Container(
                    height: 192.h,
                    decoration: BoxDecoration(color: Color(0xFF2F2F33)),
                  ),
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: AppColors.appBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
