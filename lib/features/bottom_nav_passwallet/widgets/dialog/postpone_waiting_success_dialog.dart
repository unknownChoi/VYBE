import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/passwallet_dialog.dart';

class PostponeWaitingSuccessDialog extends StatelessWidget {
  const PostponeWaitingSuccessDialog({super.key, required this.movedTeams});

  final int movedTeams;

  @override
  Widget build(BuildContext context) {
    final Widget dialogWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '변경되었습니다.',
          textAlign: TextAlign.center,
          style: _dialogTitleTextStyle,
        ),
        SizedBox(height: 12.h),
        Text(
          '순서가 $movedTeams팀 뒤로 변경되었어요.\n웨이팅 내역에서 확인하세요!',
          textAlign: TextAlign.center,
          style: _dialogDescriptionTextStyle,
        ),
        SizedBox(height: 24.h),
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.appPurpleColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              alignment: Alignment.center,
              child: Text('확인', style: _dialogButtonTextStyle),
            ),
          ),
        ),
      ],
    );

    return PasswalletDialog(dialogWidget: dialogWidget);
  }
}

TextStyle get _dialogTitleTextStyle => TextStyle(
  color: Colors.white /* White */,
  fontSize: 24.sp,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  height: 1.08,
  letterSpacing: (-0.60).sp,
);

TextStyle get _dialogDescriptionTextStyle => TextStyle(
  color: const Color(0xFFCACACB) /* Gray400 */,
  fontSize: 16.sp,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  height: 1.12,
  letterSpacing: (-0.80).sp,
);

TextStyle get _dialogButtonTextStyle => TextStyle(
  color: Colors.white /* White */,
  fontSize: 14.sp,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  height: 1.14,
  letterSpacing: (-0.35).sp,
);
