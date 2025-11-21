import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

class MenuOrderBottomBar extends StatelessWidget {
  const MenuOrderBottomBar({
    super.key,
    required this.onOpenCart,
    required this.cartCount,
    required this.onConfirm,
  });

  final VoidCallback onOpenCart;
  final int cartCount;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        height: 40.h,
        child: Row(
          children: [
            Expanded(
              child: _BottomButton(
                label: '장바구니',
                onTap: onOpenCart,
                trailing: _CartCountBadge(count: cartCount),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _BottomButton(
                label: '확인',
                onTap: onConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    required this.label,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final VoidCallback onTap;
  final Widget? trailing;

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
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 24.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            if (trailing != null) ...[
              SizedBox(width: 8.w),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

class _CartCountBadge extends StatelessWidget {
  const _CartCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      transitionBuilder: (child, animation) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: curved, child: child),
        );
      },
      child: count > 0
          ? Container(
              key: ValueKey<int>(count),
              width: 24.w,
              height: 24.w,
              decoration: const BoxDecoration(
                color: Color(0xFF622ACF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: const Color(0xFFECECEC),
                    fontSize: 11.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.10,
                    letterSpacing: -0.55,
                  ),
                ),
              ),
            )
          : const SizedBox(key: ValueKey('cart-count-empty')),
    );
  }
}
