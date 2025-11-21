import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

/// 메뉴 이미지와 이름/설명을 보여주는 헤더 섹션.
class MenuInfoHeader extends StatelessWidget {
  const MenuInfoHeader({
    super.key,
    required this.menuImagePath,
    required this.isMainMenu,
    required this.menuName,
    required this.menuDescription,
    required this.priceLabel,
  });

  final String menuImagePath;
  final bool isMainMenu;
  final String menuName;
  final String menuDescription;
  final String priceLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (menuImagePath.isNotEmpty)
          Container(
            width: double.infinity,
            height: 160.h,
            decoration: const BoxDecoration(color: Color(0xFF9F9FA1)),
            child: Center(
              child: Image.asset(
                menuImagePath,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isMainMenu)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: AppColors.appPurpleColor,
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        '대표',
                        style: TextStyle(
                          color: const Color(0xFFECECEC),
                          fontSize: 10.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                          letterSpacing: -0.50,
                        ),
                      ),
                    ),
                  if (isMainMenu) SizedBox(width: 8.w),
                  Text(
                    menuName,
                    style: TextStyle(
                      color: const Color(0xFFECECEC),
                      fontSize: 24.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.08,
                      letterSpacing: -0.60,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              if (menuDescription.isNotEmpty)
                Text(
                  menuDescription,
                  style: TextStyle(
                    color: const Color(0xFF9F9FA1),
                    fontSize: 16.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              SizedBox(height: 12.h),
              Text(
                priceLabel,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.10,
                  letterSpacing: -0.50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
