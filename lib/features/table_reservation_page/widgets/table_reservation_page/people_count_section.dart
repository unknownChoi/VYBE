import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 인원 수를 설정하는 섹션.
class PeopleCountSection extends StatelessWidget {
  const PeopleCountSection({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.minCount = 1,
  });

  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minCount;

  @override
  Widget build(BuildContext context) {
    final canDecrement = count > minCount;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onIncrement,
            child: Container(
              width: double.infinity,
              height: 40.h,
              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2F1A5A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(width: 1.w, color: const Color(0xFF7731FE)),
              ),
              child: Wrap(
                spacing: 10.w,
                runSpacing: 4.h,
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    '친구 추가',
                    style: TextStyle(
                      color: const Color(0xFFD9C5FF),
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.14,
                      letterSpacing: -0.35,
                    ),
                  ),
                  SvgPicture.asset(width: 11.w, 'assets/icons/common/plus.svg'),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: canDecrement ? onDecrement : null,
                child: Opacity(
                  opacity: canDecrement ? 1 : 0.35,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF404042),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        width: 18.w,
                        'assets/icons/common/minus.svg',
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '$count',
                    style: TextStyle(
                      color: const Color(0xFFB5FF60),
                      fontSize: 32.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.06,
                      letterSpacing: -0.80,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '명',
                    style: TextStyle(
                      color: const Color(0xFFECECEC),
                      fontSize: 20.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.10,
                      letterSpacing: -0.50,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onIncrement,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF404042),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      width: 18.w,
                      'assets/icons/common/plus.svg',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

