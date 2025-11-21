import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

/// 이용 가능한 시간대를 선택하는 가로 스크롤 섹션.
class TimeSection extends StatelessWidget {
  const TimeSection({
    super.key,
    required this.slots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  final List<String> slots;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Row(
          children: [
            ...slots.map((time) {
              final bool isSelected = time == selectedTime;
              final Color backgroundColor =
                  isSelected ? AppColors.appGreenColor : Colors.transparent;
              final Color borderColor =
                  isSelected ? AppColors.appGreenColor : const Color(0xFF2F2F33);
              final Color textColor =
                  isSelected ? Colors.black : const Color(0xFFECECEC);

              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: GestureDetector(
                  onTap: () => onTimeSelected(time),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(6.r),
                      border: Border.all(width: 1, color: borderColor),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.12,
                        letterSpacing: -0.80,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

