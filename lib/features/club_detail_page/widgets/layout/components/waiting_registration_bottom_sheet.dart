import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/club_detail_page/widgets/layout/components/waiting_modal_sheet_button.dart';

class WaitingRegistrationBottomSheet extends StatefulWidget {
  const WaitingRegistrationBottomSheet({
    super.key,
    required this.clubName,
    required this.waitingTeamCount,
    required this.expectedWaitTime,
    required this.onRegister,
  });

  final String clubName;
  final String waitingTeamCount;
  final String expectedWaitTime;
  final ValueChanged<int> onRegister;

  @override
  State<WaitingRegistrationBottomSheet> createState() =>
      _WaitingRegistrationBottomSheetState();
}

class _WaitingRegistrationBottomSheetState
    extends State<WaitingRegistrationBottomSheet> {
  int _peopleCount = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _sheetBackgroundColor,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.h,
        bottom: 37.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Text(widget.clubName, style: _titleStyle),
          ),
          _buildStatsSection(),
          SizedBox(height: 24.h),
          _buildPeopleSelector(),
          SizedBox(height: 24.h),
          _buildGuidelinesCard(),
          SizedBox(height: 24.h),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 24.h),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.w, color: _dividerColor),
        ),
      ),
      child: Row(
        children: [
          _buildStatTile(title: '현재 웨이팅', value: widget.waitingTeamCount),
          Spacer(),
          _buildStatTile(title: '에상 대기시간', value: widget.expectedWaitTime),
        ],
      ),
    );
  }

  Widget _buildPeopleSelector() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 36.w),
      child: Row(
        children: [
          Text('인원', style: _sectionLabelStyle),
          Spacer(),
          Row(
            children: [
              _buildCounterButton(
                assetPath: 'assets/icons/common/minus.svg',
                onTap: () => _updatePeopleCount(-1),
              ),
              SizedBox(width: 20.w),
              Text('$_peopleCount', style: _peopleCountStyle),
              SizedBox(width: 20.w),
              _buildCounterButton(
                assetPath: 'assets/icons/common/plus.svg',
                onTap: () => _updatePeopleCount(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: _guidelineBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('매장 웨이팅 유의사항', style: _guidelineTitleStyle),
          SizedBox(height: 12.h),
          Text(_guidelineDescription, style: _guidelineBodyStyle),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: WaitingModalSheetButton(
            filled: false,
            label: '취소',
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: WaitingModalSheetButton(
            filled: true,
            label: '웨이팅 등록하기',
            onTap: () => widget.onRegister(_peopleCount),
          ),
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(title, style: _sectionLabelStyle),
        SizedBox(height: 24.h),
        Text(value, style: _statValueStyle),
      ],
    );
  }

  Widget _buildCounterButton({
    required String assetPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(width: 1.w, color: _controlBorderColor),
        ),
        child: Center(
          child: SvgPicture.asset(assetPath, width: 10.w),
        ),
      ),
    );
  }

  void _updatePeopleCount(int delta) {
    final nextValue = _peopleCount + delta;
    if (nextValue < 1) {
      setState(() => _peopleCount = 1);
    } else if (nextValue > 10) {
      setState(() => _peopleCount = 10);
    } else {
      setState(() => _peopleCount = nextValue);
    }
  }

  static const _sheetBackgroundColor = Color(0xFF2F2F33);
  static const _dividerColor = Color(0xFF404042);
  static const _controlBorderColor = Color(0xFF979797);
  static const _guidelineBackgroundColor = Color(0xFF404042);
  static const _guidelineDescription =
      '웨이팅 등록 후, 방문을 하지 않으면 방문 이력이 노쇼로 처리될 수 있습니다. 노쇼로 처리될 경우, 이후 서비스 이용에 제한이 생길 수 있으니 이 점 확인 부탁드립니다.\n\n웨이팅을 등록하면 알림을 드립니다.';

  TextStyle get _titleStyle => const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        height: 1.08,
        letterSpacing: -0.60,
      );

  TextStyle get _sectionLabelStyle => const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w600,
        height: 1.10,
        letterSpacing: -0.50,
      );

  TextStyle get _statValueStyle => TextStyle(
        color: AppColors.appGreenColor,
        fontSize: 32,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
        height: 1.06,
        letterSpacing: -0.80,
      );

  TextStyle get _peopleCountStyle => const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w500,
        height: 1.10,
        letterSpacing: -0.50,
      );

  TextStyle get _guidelineTitleStyle => const TextStyle(
        color: Color(0xFFECECEC),
        fontSize: 14,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w700,
        height: 1.14,
        letterSpacing: -0.35,
      );

  TextStyle get _guidelineBodyStyle => const TextStyle(
        color: Color(0xFFECECEC),
        fontSize: 12,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        height: 1.17,
        letterSpacing: -0.30,
      );
}
