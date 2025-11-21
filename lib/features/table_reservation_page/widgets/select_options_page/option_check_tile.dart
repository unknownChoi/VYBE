import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

/// 옵션 체크박스 항목을 나타내는 공통 위젯.
class OptionCheckTile extends StatelessWidget {
  const OptionCheckTile({
    super.key,
    required this.checked,
    required this.label,
    required this.trailingPrice,
    required this.onChanged,
  });

  final bool checked;
  final String label;
  final String trailingPrice;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: Checkbox(
                value: checked,
                onChanged: onChanged,
                side: BorderSide(color: const Color(0xFFCACACB), width: 1.w),
                fillColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? AppColors.appGreenColor
                      : Colors.transparent,
                ),
                checkColor: AppColors.appBackgroundColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: const Color(0xFFECECEC),
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.12,
                  letterSpacing: -0.80,
                ),
              ),
            ),
            Text(
              trailingPrice,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.12,
                letterSpacing: -0.80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
