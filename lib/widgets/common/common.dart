import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/constants/AppColors.dart';

import 'package:vybe/constants/app_textstyles.dart';

class MenuCard extends StatelessWidget {
  final String menuName;
  final int menuPrice;
  final String menuImageSrc;
  final bool isRepresentative;

  const MenuCard({
    super.key,
    required this.menuName,
    required this.menuPrice,
    this.menuImageSrc = '',
    this.isRepresentative = false,
  });

  @override
  Widget build(BuildContext context) {
    // Reuse NumberFormat to avoid allocating each build.
    final NumberFormat priceFormat = _priceFormatWon;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isRepresentative)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 2.h,
                      ),
                      margin: EdgeInsets.only(right: 4.w),
                      decoration: BoxDecoration(
                        color: AppColors.appPurpleColor,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Center(
                        child: Text("대표", style: AppTextStyles.representative),
                      ),
                    ),
                  Text(menuName, style: AppTextStyles.body),
                ],
              ),
              SizedBox(height: 10.h),
              Text(priceFormat.format(menuPrice), style: AppTextStyles.price),
            ],
          ),
        ),
        if (menuImageSrc.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              menuImageSrc,
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
          )
        else
          SizedBox(width: 100.w, height: 100.h),
      ],
    );
  }
}

// Top-level reusable formatter to avoid rebuild overhead.
final NumberFormat _priceFormatWon = NumberFormat('###,###원');
