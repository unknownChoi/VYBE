import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class OrderMenuItemCard extends StatelessWidget {
  const OrderMenuItemCard({
    super.key,
    required this.menuName,
    required this.menuPrice,
    required this.menuImageSrc,
    required this.menuDescription,
    required this.isMainMenu,
    required this.onAddToCart,
  });

  final String menuName;
  final int menuPrice;
  final String menuImageSrc;
  final String menuDescription;
  final bool isMainMenu;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final NumberFormat wonFormat = NumberFormat('#,###');
    final double cardHeight = 124.h;
    final double imageSize = 100.w;
    final double badgeSize = 32.w;

    return SizedBox(
      height: cardHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _MenuInfo(
                isMainMenu: isMainMenu,
                menuName: menuName,
                menuDescription: menuDescription,
                priceText: '${wonFormat.format(menuPrice)}원',
              ),
            ),
            if (menuImageSrc.isNotEmpty)
              _MenuImageWithBadge(
                imagePath: menuImageSrc,
                imageSize: imageSize,
                badgeSize: badgeSize,
                onTap: onAddToCart,
              )
            else
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: GestureDetector(
                  onTap: onAddToCart,
                  child: _CartBadge(size: badgeSize),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuInfo extends StatelessWidget {
  const _MenuInfo({
    required this.isMainMenu,
    required this.menuName,
    required this.menuDescription,
    required this.priceText,
  });

  final bool isMainMenu;
  final String menuName;
  final String menuDescription;
  final String priceText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isMainMenu)
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.appPurpleColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text('대표', style: AppTextStyles.representative),
                ),
              ),
            Text(menuName, style: AppTextStyles.body),
          ],
        ),
        SizedBox(height: 8.h),
        if (menuDescription.isNotEmpty)
          Text(
            menuDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF9F9FA1),
              fontSize: 12.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.17,
              letterSpacing: -0.30,
            ),
          ),
        SizedBox(height: 12.h),
        Text(priceText, style: AppTextStyles.price),
      ],
    );
  }
}

class _MenuImageWithBadge extends StatelessWidget {
  const _MenuImageWithBadge({
    required this.imagePath,
    required this.imageSize,
    required this.badgeSize,
    required this.onTap,
  });

  final String imagePath;
  final double imageSize;
  final double badgeSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
            Positioned(
              right: 6.w,
              bottom: 6.h,
              child: GestureDetector(
                onTap: onTap,
                child: _CartBadge(size: badgeSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF404042),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset('assets/icons/table_reservation_page/cart.svg'),
      ),
    );
  }
}
