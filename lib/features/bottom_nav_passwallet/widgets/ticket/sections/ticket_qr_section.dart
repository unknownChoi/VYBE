import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';

class TicketQrSection extends StatelessWidget {
  const TicketQrSection({
    super.key,
    required this.status,
    required this.isQrExpired,
    required this.qrTimeText,
    required this.onRefresh,
  });

  final PassStatus status;
  final bool isQrExpired;
  final String qrTimeText;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 345.w,
          height: 227.h,
          color: const Color(0xFF2F2F33),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 120.w, height: 120.w, color: Colors.white),
                  if (status != PassStatus.waiting)
                    Positioned(
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: 120.w,
                        height: 120.w,
                        child: Image.asset(
                          'assets/images/bottom_nav_passwallet/test_qr.png',
                          width: 110.w,
                          height: 114.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  if (isQrExpired)
                    Positioned(
                      left: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: onRefresh,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              width: 120.w,
                              height: 120.w,
                              alignment: Alignment.center,
                              color: const Color(0xFF2F2F33).withOpacity(0.1),
                              child: Icon(
                                size: 50.sp,
                                Icons.refresh,
                                color: AppColors.appPurpleColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 12.h),
              if (status == PassStatus.entering || status == PassStatus.entered)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isQrExpired ? "요청 시간 만료" : '남은 시간',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.businessHours.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          isQrExpired ? "" : qrTimeText,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.businessHours.copyWith(
                            color: const Color(0xFFB5FF60),
                            fontWeight: FontWeight.w700,
                            letterSpacing: (-0.35).w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '입장 시 직원에게 QR을 보여주세요.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 18.sp,
                        letterSpacing: (-0.90).w,
                        height: 1.11,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (status == PassStatus.waiting || status == PassStatus.reservation)
          Positioned(
            left: 0,
            right: 0,
            child: SizedBox(
              width: 345.w,
              height: 227.h,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    alignment: Alignment.center,
                    color: const Color(0xFF2F2F33).withOpacity(0.6),
                    child: Text(
                      "입장시\nQR이 활성화 됩니다.",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.sectionTitle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: (-12).w,
          height: 14.h,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double stripH = 14.h;
              final double cy = stripH / 2;
              final double margin = 12.w;
              final double usableW = (constraints.maxWidth - margin * 2).clamp(
                0.0,
                double.infinity,
              );
              const int count = 12;
              final double step = (count <= 1) ? 0 : usableW / (count - 1);

              return Stack(
                clipBehavior: Clip.none,
                children: List.generate(count, (i) {
                  final double x = margin + step * i;
                  return Positioned(
                    left: x - 12.w,
                    top: cy - 12.w,
                    width: 24.w,
                    height: 24.w,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.appBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
