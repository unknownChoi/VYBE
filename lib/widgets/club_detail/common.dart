import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vybe/constants/app_textstyles.dart';

import '../../constants/appcolors.dart';

class InfoRow extends StatelessWidget {
  final String icon;
  final String? text;
  final Widget? widget;
  final bool isLink;

  const InfoRow({
    required this.icon,
    this.text,
    this.widget,
    this.isLink = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: 16.w,
          colorFilter: const ColorFilter.mode(
            Color(0xFF535355),
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 12.w),
        if (widget != null)
          Expanded(child: widget!)
        else
          Expanded(
            child: Text(
              text!,
              style: isLink ? AppTextStyles.link : AppTextStyles.body,
            ),
          ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    required this.title,
    this.showSeeAll = true,
    this.onSeeAllTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (showSeeAll) ...[
          const Spacer(),
          GestureDetector(
            onTap: onSeeAllTap ?? () {},
            child: Row(
              children: [
                Text("전체보기", style: AppTextStyles.seeAll),
                SizedBox(width: 4.w),
                SvgPicture.asset(
                  'assets/icons/club_detail_main/arrow_right.svg',
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8.h,
      color: const Color(0xFF2F2F33),
    );
  }
}

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
                Text('${_wonFormat.format(menuPrice)}원', style: AppTextStyles.price),
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

// Reusable price formatter to avoid allocating per build.
final NumberFormat _wonFormat = NumberFormat('#,###');

class Tag extends StatelessWidget {
  final String text;
  const Tag({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: const Color(0xFF2F2F33),
      ),
      child: Center(child: Text(text, style: AppTextStyles.tag)),
    );
  }
}

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
        color: isSelected ? AppColors.appPurpleColor : Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          width: 1.w,
          color:
              isSelected ? AppColors.appPurpleColor : const Color(0xFF404042),
        ),
      ),
      child: Center(child: Text(category, style: AppTextStyles.category)),
    );
  }
}

class CallButton extends StatelessWidget {
  const CallButton({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('전화 앱을 열 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _makePhoneCall('010 5909195');
        print("de");
      },
      child: Container(
        width: 60.w,
        height: 26.h,
        decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: const Color(0xFF9F9FA1)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/icons/club_detail_main/call.svg',
              width: 14.w,
            ),
            Text("전화", style: AppTextStyles.callButtonText),
          ],
        ),
      ),
    );
  }
}

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

class NearClubCard extends StatelessWidget {
  final String clubName;
  final String clubCity;
  final String clubType;
  final String clubImageSrc;

  const NearClubCard({
    super.key,
    required this.clubName,
    required this.clubCity,
    required this.clubType,
    required this.clubImageSrc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/near_club/test_1.png'),
        SizedBox(height: 8.h),
        Text(
          clubName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 1.14.h,
            letterSpacing: -0.70,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              clubCity,
              style: TextStyle(
                color: const Color(0xFF9F9FA1),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.17.h,
                letterSpacing: -0.30,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/icons/club_detail_main/dot.svg'),
            SizedBox(width: 4.w),
            Text(
              clubType,
              style: TextStyle(
                color: const Color(0xFF9F9FA1),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.17.h,
                letterSpacing: -0.30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
