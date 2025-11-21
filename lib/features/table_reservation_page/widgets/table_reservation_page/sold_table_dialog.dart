import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/dialong_widget.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/dialog_button.dart';

/// 이미 판매된 테이블 선택 시 노출되는 안내 다이얼로그.
class SoldTableDialog extends StatelessWidget {
  const SoldTableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: DialongWidget(
        dialogWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '이미 판매된 테이블입니다',
              textAlign: TextAlign.center,
              style: AppTextStyles.dialogTitleTextStyle,
            ),
            SizedBox(height: 12.h),
            Text(
              '다른 테이블을 선택해주세요.',
              textAlign: TextAlign.center,
              style: AppTextStyles.dialogDescriptionTextStyle,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                DialonButton(
                  buttonText: '확인',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

