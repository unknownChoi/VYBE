import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;

  const CategoryChip({
    required this.category,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.appPurpleColor : Color(0xFF535355),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          width: 1.w,
          color: isSelected
              ? AppColors.appPurpleColor
              : const Color(0xFF535355),
        ),
      ),
      child: Center(child: Text(category, style: AppTextStyles.category)),
    );
  }
}
