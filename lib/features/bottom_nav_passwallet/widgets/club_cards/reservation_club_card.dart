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

  Color get _statusChipBackgroundColor =>
      status == ReservationStatus.canceled
          ? const Color(0xFF535355)
          : AppColors.appGreenColor;

  Color get _statusChipTextColor => status == ReservationStatus.canceled
      ? Colors.white
      : const Color(0xFF2F2F33);

  bool get _showDDay => status == ReservationStatus.confirmed;

  Widget _buildBadgeChip({
    required String label,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 11.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.27,
            letterSpacing: (-0.55).w,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    final infoTextStyle = TextStyle(
      color: const Color(0xFFCACACB),
      fontSize: 14.sp,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      height: 1.14,
      letterSpacing: (-0.70).w,
    );
    final infoItems = <String>[
      scheduledDate,
      scheduledTime,
      '$enteredCount명',
    ];

    return Row(
      children: [
        for (int i = 0; i < infoItems.length; i++) ...[
          Text(infoItems[i], style: infoTextStyle),
          if (i < infoItems.length - 1) ...[
            SizedBox(width: 8.w),
            SvgPicture.asset(
              'assets/icons/common/dot.svg',
              width: 3.w,
              color: const Color(0xFFCACACB),
            ),
            SizedBox(width: 8.w),
          ],
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color backgroundColor,
    Color textColor = const Color(0xFFECECEC),
  }) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 14.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 1.14,
          letterSpacing: (-0.35).w,
        ),
      ),
    );
  }

  Widget _buildActions() {
    if (status == ReservationStatus.canceled) {
      return SizedBox(
        width: double.infinity,
        child: _buildActionButton(
          label: '내역 삭제하기',
          backgroundColor: const Color(0xFF535355),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            label: '예약 취소하기',
            backgroundColor: const Color(0xFF535355),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            label: '예약 변경하기',
            backgroundColor: AppColors.appPurpleColor,
          ),
        ),
      ],
    );
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
                _buildBadgeChip(
                  label: _statusLabel(status),
                  backgroundColor: _statusChipBackgroundColor,
                  textColor: _statusChipTextColor,
                ),
                if (_showDDay) ...[
                  SizedBox(width: 8.w),
                  _buildBadgeChip(
                    label: 'D-10',
                    backgroundColor: const Color(0xFF404042),
                    textColor: const Color(0xFFCACACB),
                  ),
                ],
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
                    _buildInfoRow(),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildActions(),
          ],
        ),
      ),
    );
  }
}
