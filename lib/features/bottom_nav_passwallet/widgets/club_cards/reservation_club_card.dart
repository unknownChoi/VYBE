import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';

class ReservationClubCard extends StatelessWidget {
  const ReservationClubCard({
    super.key,
    required this.status,
    required this.clubName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.enteredCount,
    required this.imageSrc,
  });

  final ReservationStatus status;
  final String clubName;
  final String scheduledDate;
  final String scheduledTime;
  final int enteredCount;
  final String imageSrc;

  String _statusLabel(ReservationStatus status) {
    switch (status) {
      case ReservationStatus.pendingApproval:
        return '수락 대기중';
      case ReservationStatus.canceled:
        return '예약 취소';
      case ReservationStatus.confirmed:
        return '예약 완료';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: status == ReservationStatus.canceled
                        ? const Color(0xFF535355)
                        : AppColors.appGreenColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Center(
                    child: Text(
                      _statusLabel(status),
                      style: TextStyle(
                        color: status == ReservationStatus.canceled
                            ? Colors.white
                            : const Color(0xFF2F2F33),
                        fontSize: 11.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.27,
                        letterSpacing: (-0.55).w,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                if (status == ReservationStatus.confirmed)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF404042),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Center(
                      child: Text(
                        'D-10',
                        style: TextStyle(
                          color: const Color(0xFFCACACB),
                          fontSize: 11.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.27,
                          letterSpacing: (-0.55).w,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Image.asset(imageSrc),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clubName,
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
                      children: [
                        Text(
                          scheduledDate,
                          style: TextStyle(
                            color: const Color(0xFFCACACB),
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
                          width: 3.w,
                          color: const Color(0xFFCACACB),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          scheduledTime,
                          style: TextStyle(
                            color: const Color(0xFFCACACB),
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
                          width: 3.w,
                          color: const Color(0xFFCACACB),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '$enteredCount명',
                          style: TextStyle(
                            color: const Color(0xFFCACACB),
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
              ],
            ),
            SizedBox(height: 12.h),
            if (status == ReservationStatus.canceled)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 11.h),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF535355)),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  '예약이 취소되었어요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACB),
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                    letterSpacing: (-0.35).w,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
