import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/passwallet_dialog.dart';

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
          style: TextStyle(
            color: Colors.white /* White */,
            fontSize: 24,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.08,
            letterSpacing: -0.60,
          ),
        ),
      ],
    );
    return PasswalletDialog(dialogWidget: dialogWidget);
  }
}
