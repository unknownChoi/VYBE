import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class DialonButton extends StatelessWidget {
  const DialonButton({super.key, required this.buttonText, this.onTap});

  final String buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = AppTextStyles.dialogButtonTextStyle;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 40.w),
          decoration: BoxDecoration(
            color: buttonText == "취소"
                ? const Color(0xFF535355)
                : AppColors.appPurpleColor,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: buttonTextStyle,
            ),
          ),
        ),
      ),
    );
  }
}
