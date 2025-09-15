import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/feature_item.dart';

class FeatureGridItem extends StatelessWidget {
  final FeatureItem item;
  final bool isVybe;
  final VoidCallback onTap;

  const FeatureGridItem({
    super.key,
    required this.item,
    this.isVybe = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isVybe ? _buildGradientBorderIcon() : _buildSimpleIcon(),
          SizedBox(height: 4.h),
          Text(
            item.label,
            style: TextStyle(
              color: const Color(0xFFECECEC),
              fontSize: 12.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.60.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBorderIcon() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFC1EF74),
            Color(0xFFF192DF),
            Color(0xFF7731FD),
            Color(0xFF7731FD),
            Color(0xFF7731FD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: const Color(0xFF2F2F33),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Center(
          child: SizedBox(
            width: 40.sp,
            height: 40.sp,
            child: SvgPicture.asset(item.iconPath),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleIcon() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: SizedBox(
          width: 40.sp,
          height: 40.sp,
          child: SvgPicture.asset(item.iconPath),
        ),
      ),
    );
  }
}
