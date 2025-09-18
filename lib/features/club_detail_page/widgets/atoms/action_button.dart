import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final bool outlined;

  const ActionButton({required this.text, this.outlined = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : AppColors.appPurpleColor,
        border:
            outlined
                ? Border.all(color: AppColors.appPurpleColor, width: 1.w)
                : null,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(child: Text(text, style: AppTextStyles.actionButton)),
    );
  }
}
