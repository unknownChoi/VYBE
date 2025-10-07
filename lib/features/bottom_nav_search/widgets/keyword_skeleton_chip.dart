import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeywordSkeletonChip extends StatelessWidget {
  const KeywordSkeletonChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      width: 88.w,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(999.r),
      ),
    );
  }
}
