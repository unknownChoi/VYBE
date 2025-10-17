import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class ClubDetailDialogButton extends StatelessWidget {
  const ClubDetailDialogButton({
    super.key,
    required this.label,
    this.onTap,
  });

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.appPurpleColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(label, style: AppTextStyles.dialogButtonTextStyle),
        ),
      ),
    );
  }
}
