import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:vybe/core/app_text_style.dart';

class TicketHeader extends StatelessWidget {
  const TicketHeader({
    super.key,
    required this.clubName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.statusLabel,
  });

  final String clubName;
  final String scheduledDate;
  final String scheduledTime;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 98.h,
      decoration: BoxDecoration(
        color: const Color(
          0xFF7E33FF,
        ), // AppColors.appPurpleColor를 쓰려면 import 교체
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(clubName, style: AppTextStyles.title),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                scheduledDate,
                textAlign: TextAlign.center,
                style: AppTextStyles.businessHours.copyWith(
                  color: const Color(0xFFECECEC),
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
                scheduledTime,
                textAlign: TextAlign.center,
                style: AppTextStyles.businessHours.copyWith(
                  color: const Color(0xFFECECEC),
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
                statusLabel,
                textAlign: TextAlign.center,
                style: AppTextStyles.businessHours.copyWith(
                  color: const Color(0xFFECECEC),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
