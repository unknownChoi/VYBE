import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/dialog_button.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/passwallet_dialog.dart';

class PostponeWaitingDialog extends StatefulWidget {
  const PostponeWaitingDialog({super.key});

  @override
  State<PostponeWaitingDialog> createState() => _PostponeWaitingDialogState();
}

class _PostponeWaitingDialogState extends State<PostponeWaitingDialog> {
  int _selectedTeam = 1;

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = AppTextStyles.dialogTitleTextStyle;
    final descriptionTextStyle = AppTextStyles.dialogDescriptionTextStyle;
    final Widget dialogWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('웨이팅 순서 변경', textAlign: TextAlign.center, style: titleTextStyle),
        SizedBox(height: 12.h),
        Text(
          '얼마나 뒤로 미루시겠어요?',
          textAlign: TextAlign.center,
          style: descriptionTextStyle,
        ),
        SizedBox(height: 12.h),
        PostponeTeamStepper(
          maxTeamCount: 10,
          initialTeamCount: _selectedTeam,
          onChanged: (v) => setState(() => _selectedTeam = v),
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
              onTap: () => Navigator.of(context).pop(_selectedTeam),
            ),
          ],
        ),
      ],
    );

    return DefaultTextStyle(
      style: const TextStyle(),
      child: Center(child: PasswalletDialog(dialogWidget: dialogWidget)),
    );
  }
}

class PostponeTeamStepper extends StatefulWidget {
  const PostponeTeamStepper({
    super.key,
    this.initialTeamCount = 1,
    this.minTeamCount = 1,
    this.maxTeamCount,
    this.onChanged,
  }) : assert(minTeamCount > 0, 'Team count must be greater than zero.'),
       assert(
         maxTeamCount == null || maxTeamCount >= minTeamCount,
         'maxTeamCount must be null or greater than or equal to minTeamCount.',
       );

  final int initialTeamCount;
  final int minTeamCount;
  final int? maxTeamCount;
  final ValueChanged<int>? onChanged;

  @override
  State<PostponeTeamStepper> createState() => _PostponeTeamStepperState();
}

class _PostponeTeamStepperState extends State<PostponeTeamStepper> {
  late int _teamCount;

  @override
  void initState() {
    super.initState();
    _teamCount = _clampTeamCount(widget.initialTeamCount);
  }

  @override
  void didUpdateWidget(covariant PostponeTeamStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTeamCount != widget.initialTeamCount) {
      _teamCount = _clampTeamCount(widget.initialTeamCount);
    }
  }

  bool get _canDecrement => _teamCount > widget.minTeamCount;
  bool get _canIncrement =>
      widget.maxTeamCount == null || _teamCount < widget.maxTeamCount!;

  int _clampTeamCount(int value) {
    final min = widget.minTeamCount;
    final max = widget.maxTeamCount;
    if (value < min) return min;
    if (max != null && value > max) return max;
    return value;
  }

  void _updateTeamCount(int delta) {
    final updated = _clampTeamCount(_teamCount + delta);
    if (updated == _teamCount) return;
    setState(() => _teamCount = updated);
    widget.onChanged?.call(_teamCount);
  }

  @override
  Widget build(BuildContext context) {
    final teamCountTextStyle = AppTextStyles.teamCountTextStyle;
    final teamSuffixTextStyle = AppTextStyles.teamSuffixTextStyle;

    return Row(
      children: [
        _StepperCircleButton(
          assetPath: 'assets/icons/postpone_waiting/minus.svg',
          onTap: _canDecrement ? () => _updateTeamCount(-1) : null,
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 42.w,
              child: Text(
                '$_teamCount',
                textAlign: TextAlign.center,
                style: teamCountTextStyle,
              ),
            ),
            SizedBox(width: 4.w),
            Text('팀', textAlign: TextAlign.center, style: teamSuffixTextStyle),
          ],
        ),
        const Spacer(),
        _StepperCircleButton(
          assetPath: 'assets/icons/postpone_waiting/plus.svg',
          onTap: _canIncrement ? () => _updateTeamCount(1) : null,
        ),
      ],
    );
  }
}

class _StepperCircleButton extends StatelessWidget {
  const _StepperCircleButton({required this.assetPath, this.onTap});

  final String assetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Opacity(
      opacity: isEnabled ? 1 : 0.4,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFF404042),
            borderRadius: BorderRadius.circular(999.r),
          ),
          child: Center(child: SvgPicture.asset(assetPath, width: 18.w)),
        ),
      ),
    );
  }
}
