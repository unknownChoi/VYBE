import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';

class HistoryClubCard extends StatelessWidget {
  const HistoryClubCard({
    super.key,
    required this.reviewStatus,
    required this.clubName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.enteredCount,
    required this.imageSrc,
    required this.isReservation,
  });

  final HistoryClubCardReviewStatus reviewStatus;
  final String clubName;
  final String scheduledDate;
  final String scheduledTime;
  final int enteredCount;
  final String imageSrc;
  final bool isReservation;

  String get _badgeLabel => isReservation ? '예약' : '현장 웨이팅';

  TextStyle get _badgeTextStyle => TextStyle(
        color: Colors.white,
        fontSize: 11.sp,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        height: 1.27,
        letterSpacing: (-0.55).w,
      );

  TextStyle get _infoTextStyle => TextStyle(
        color: const Color(0xFFCACACB),
        fontSize: 14.sp,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        height: 1.14,
        letterSpacing: (-0.70).w,
      );

  List<String> get _infoItems => [
        scheduledDate,
        scheduledTime,
        '$enteredCount명',
      ];

  Widget _buildBadgeChip() {
    return Container(
      height: 18.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: const Color(0xFF535355),
        borderRadius: BorderRadius.circular(999.r),
      ),
      alignment: Alignment.center,
      child: Text(_badgeLabel, style: _badgeTextStyle),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        for (int i = 0; i < _infoItems.length; i++) ...[
          Text(_infoItems[i], style: _infoTextStyle),
          if (i < _infoItems.length - 1) ...[
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

  Widget _buildStarRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i == 4 ? 0.0 : 8.w),
          child: SvgPicture.asset(
            'assets/icons/common/star.svg',
            width: 29.w,
            height: 29.w,
            color: Colors.white,
          ),
        );
      }),
    );
  }

  Widget _buildReviewSection() {
    switch (reviewStatus) {
      case HistoryClubCardReviewStatus.notReviewed:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 11.h),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appGreenColor),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '잊기 전에 ',
                      style: TextStyle(
                        color: const Color(0xFFB5FF60),
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.14,
                        letterSpacing: (-0.35).w,
                      ),
                    ),
                    TextSpan(
                      text: '후기를 남겨보세요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.14,
                        letterSpacing: (-0.35).w,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              _buildStarRow(),
            ],
          ),
        );
      case HistoryClubCardReviewStatus.expired:
        return Container(
          width: double.infinity,
          height: 40.h,
          decoration: BoxDecoration(
            border: Border.all(width: 1.w, color: const Color(0xFF2F2F33)),
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Text(
            '리뷰 작성 기간이 만료되었어요',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF707071),
              fontSize: 14.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1.14,
              letterSpacing: (-0.35).w,
            ),
          ),
        );
      case HistoryClubCardReviewStatus.reviewed:
        return Row(
          children: [
            Expanded(
              child: Container(
                height: 40.h,
                padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 11.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F1A5A),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: const Color(0xFF7731FE),
                    width: 1.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '내가 쓴 리뷰',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.14,
                    letterSpacing: (-0.35).w,
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        children: [
          Row(
            children: [
              _buildBadgeChip(),
            ],
          ),
          SizedBox(height: 12.h),
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
          _buildReviewSection(),
        ],
      ),
    );
  }
}
