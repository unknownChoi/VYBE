import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/dialong_widget.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/dialog_button.dart';

class CancelWaitingSuccessDialog extends StatelessWidget {
  const CancelWaitingSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final Widget dialogWidget = Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Text(
          '웨이팅 취소 완료',
          textAlign: TextAlign.center,
          style: AppTextStyles.dialogTitleTextStyle,
        ),
        SizedBox(height: 24.h),
        Text(
          '웨이팅이 취소됐어요.',
          textAlign: TextAlign.center,
          style: AppTextStyles.dialogDescriptionTextStyle,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
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
