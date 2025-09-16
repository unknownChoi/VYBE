import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NearClubCard extends StatelessWidget {
  final String clubName;
  final String clubCity;
  final String clubType;
  final String clubImageSrc;

  const NearClubCard({
    super.key,
    required this.clubName,
    required this.clubCity,
    required this.clubType,
    required this.clubImageSrc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(clubImageSrc),
        SizedBox(height: 8.h),
        Text(
          clubName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 1.14.h,
            letterSpacing: -0.70,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              clubCity,
              style: TextStyle(
                color: const Color(0xFF9F9FA1),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.17.h,
                letterSpacing: -0.30,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/icons/club_detail_main/dot.svg'),
            SizedBox(width: 4.w),
            Text(
              clubType,
              style: TextStyle(
                color: const Color(0xFF9F9FA1),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.17.h,
                letterSpacing: -0.30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
