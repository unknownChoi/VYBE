import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/dialong_widget.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/dialog_button.dart';

class CancelWaitingConfirmDialog extends StatelessWidget {
  const CancelWaitingConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget dialogWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '웨이팅을 정말 \n취소하시겠어요?',
          textAlign: TextAlign.center,
          style: AppTextStyles.dialogTitleTextStyle,
        ),
        SizedBox(height: 24.h),
        Text(
          '한 번 취소하면 기존의 순번은 사라지고 \n다시 복구할 수 없습니다.',
          textAlign: TextAlign.center,
          style: AppTextStyles.dialogDescriptionTextStyle,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            // 취소: 기본 동작(닫기)
            DialonButton(
              buttonText: "취소",
              onTap: () => Navigator.of(context).pop(null),
            ),
            SizedBox(width: 12.w),
            // 확인: 부모에서 연쇄 다이얼로그 로직 주입
            DialonButton(
              buttonText: "확인",
              onTap: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      ],
    );
    return DefaultTextStyle(
      style: const TextStyle(),
      child: Center(child: DialongWidget(dialogWidget: dialogWidget)),
    );
  }
}
