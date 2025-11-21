import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 수량 조절 버튼(증가/감소)을 포함한 위젯.
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '수량',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.10,
            letterSpacing: -0.50,
          ),
        ),
        const Spacer(),
        CountButton(
          width: 32,
          height: 32,
          svgPath: 'assets/icons/common/minus.svg',
          onTap: onDecrease,
          isEnabled: quantity > 1,
        ),
        SizedBox(width: 8.w),
        Text(
          '$quantity',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFECECEC),
            fontSize: 20.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.10,
            letterSpacing: -0.50,
          ),
        ),
        SizedBox(width: 8.w),
        CountButton(
          width: 32,
          height: 32,
          svgPath: 'assets/icons/common/plus.svg',
          onTap: onIncrease,
        ),
      ],
    );
  }
}

class CountButton extends StatelessWidget {
  const CountButton({
    super.key,
    required this.svgPath,
    required this.width,
    required this.height,
    this.onTap,
    this.isEnabled = true,
  });

  final String svgPath;
  final int width;
  final int height;
  final VoidCallback? onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled ? const Color(0xFF404042) : const Color(0xFF2C2C2E),
        ),
        child: Center(
          child: SvgPicture.asset(
            width: 12.w,
            svgPath,
            colorFilter: isEnabled
                ? null
                : const ColorFilter.mode(Color(0xFF6C6C70), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
