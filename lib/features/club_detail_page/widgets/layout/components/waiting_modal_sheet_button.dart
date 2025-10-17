import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

class WaitingModalSheetButton extends StatelessWidget {
  const WaitingModalSheetButton({
    super.key,
    required this.filled,
    required this.label,
    this.onTap,
  });

  final bool filled;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: filled ? AppColors.appPurpleColor : null,
          border: filled
              ? null
              : Border.all(width: 1.w, color: const Color(0xFF535355)),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFECECEC),
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
