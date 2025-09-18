import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

final NumberFormat _wonFormat = NumberFormat('#,###');

class MenuItemCard extends StatelessWidget {
  final String menuName;
  final int menuPrice;
  final String menuImageSrc;
  final bool isMainMenu;

  const MenuItemCard({
    required this.menuName,
    required this.menuPrice,
    required this.menuImageSrc,
    required this.isMainMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (isMainMenu)
                      Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.appPurpleColor,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            "대표",
                            style: AppTextStyles.representative,
                          ),
                        ),
                      ),
                    Text(menuName, style: AppTextStyles.body),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  '${_wonFormat.format(menuPrice)}원',
                  style: AppTextStyles.price,
                ),
              ],
            ),
            if (menuImageSrc.isNotEmpty) ...[
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  menuImageSrc,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
