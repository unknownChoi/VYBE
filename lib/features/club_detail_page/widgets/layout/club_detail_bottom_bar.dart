import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/dialong_widget.dart';
import 'package:vybe/core/utils/dialog_launcher.dart';
import 'package:vybe/features/club_detail_page/widgets/atoms/action_button.dart';
import 'package:vybe/features/club_detail_page/widgets/layout/components/club_detail_dialog_button.dart';
import 'package:vybe/features/club_detail_page/widgets/layout/components/waiting_registration_bottom_sheet.dart';
import 'package:vybe/features/main_shell/screens/main_shell.dart';
import 'package:vybe/features/table_reservation_page/screens/table_reservation_page.dart';

class ClubDetailBottomBar extends StatelessWidget {
  const ClubDetailBottomBar({super.key, required this.clubName});

  final String clubName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      height: 92.h,
      color: const Color(0xFF1B1B1D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/club_detail/heart.svg'),
              SizedBox(height: 2.h),
              Text('000', style: AppTextStyles.bottomBarText),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showWaitingBottomSheet(context),
            child: const ActionButton(text: '웨이팅 등록', outlined: true),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TableReservationPage(clubName: clubName),
                ),
              );
            },
            child: const ActionButton(text: '테이블 예약'),
          ),
        ],
      ),
    );
  }

  void _showWaitingBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return WaitingRegistrationBottomSheet(
          clubName: clubName,
          waitingTeamCount: '2팀',
          expectedWaitTime: '40분',
          onRegister: (_) {
            Navigator.pop(sheetContext);
            _showWaitingRegisteredDialog(context);
          },
        );
      },
    );
  }

  Future<void> _showWaitingRegisteredDialog(BuildContext context) {
    return showScaleBlurDialog<void>(
      context,
      DialongWidget(
        dialogWidget: DefaultTextStyle(
          style: const TextStyle(),
          child: _buildWaitingDialogContent(context),
        ),
      ),
    );
  }

  Widget _buildWaitingDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('웨이팅 등록 완료!', style: AppTextStyles.dialogTitleTextStyle),
        SizedBox(height: 12.h),
        Text(
          '요청하신 웨이팅이 접수되었어요.',
          style: AppTextStyles.dialogDescriptionTextStyle,
        ),
        SizedBox(height: 4.h),
        Text(
          '진행 상황은 알람으로 알려드려요!',
          style: AppTextStyles.dialogDescriptionTextStyle,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(
              child: ClubDetailDialogButton(
                label: '확인',
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ClubDetailDialogButton(
                label: '웨이팅 내역 보기',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const MainShell(initialIndex: 2),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
