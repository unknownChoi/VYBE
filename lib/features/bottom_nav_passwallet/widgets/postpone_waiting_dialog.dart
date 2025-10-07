import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';

class PostponeWaitingDialog extends StatefulWidget {
  const PostponeWaitingDialog({super.key});

  @override
  State<PostponeWaitingDialog> createState() => _PostponeWaitingDialogState();
}

class _PostponeWaitingDialogState extends State<PostponeWaitingDialog> {
  @override
  Widget build(BuildContext context) {
    final titleTextStyle = _dialogTitleTextStyle;
    final descriptionTextStyle = _dialogDescriptionTextStyle;

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: Center(
        child: Container(
          width: 353.w,
          height: 224.h,
          padding: EdgeInsets.symmetric(horizontal: 34.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2F2F33),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            children: [
              SizedBox(height: 34.h),
              Text(
                '웨이팅 순서 변경',
                textAlign: TextAlign.center,
                style: titleTextStyle,
              ),
              SizedBox(height: 12.h),
              Text(
                '얼마나 뒤로 미루시겠어요?',
                textAlign: TextAlign.center,
                style: descriptionTextStyle,
              ),
              SizedBox(height: 12.h),
              PostponeTeamStepper(maxTeamCount: 10),
              SizedBox(height: 24.h),
              Row(
                children: [
                  PostponeWaitingButton(buttonText: "취소"),
                  SizedBox(width: 12.w),
                  PostponeWaitingButton(buttonText: "확인"),
                ],
              ),
            ],
          ),
        ),
      ),
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

    if (value < min) {
      return min;
    }

    if (max != null && value > max) {
      return max;
    }

    return value;
  }

  void _updateTeamCount(int delta) {
    final updated = _clampTeamCount(_teamCount + delta);
    if (updated == _teamCount) {
      return;
    }

    setState(() {
      _teamCount = updated;
    });

    widget.onChanged?.call(_teamCount);
  }

  @override
  Widget build(BuildContext context) {
    final teamCountTextStyle = _teamCountTextStyle;
    final teamSuffixTextStyle = _teamSuffixTextStyle;

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

class PostponeWaitingButton extends StatelessWidget {
  const PostponeWaitingButton({super.key, required this.buttonText});
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = _dialogButtonTextStyle;

    return Expanded(
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 40.w),
        decoration: BoxDecoration(
          color: buttonText == "취소"
              ? const Color(0xFF535355)
              : AppColors.appPurpleColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: buttonTextStyle,
          ),
        ),
      ),
    );
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

TextStyle get _teamCountTextStyle => TextStyle(
  color: const Color(0xFFB5FF60) /* Main-Lime500 */,
  fontSize: 32.sp,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w700,
  height: 1.06,
  letterSpacing: (-0.80).sp,
);

TextStyle get _teamSuffixTextStyle => TextStyle(
  color: const Color(0xFFECECEC) /* Gray200 */,
  fontSize: 20.sp,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w500,
  height: 1.10,
  letterSpacing: (-0.50).sp,
);

TextStyle get _dialogButtonTextStyle => TextStyle(
  color: Colors.white /* White */,
  fontSize: 14.sp,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  height: 1.14,
  letterSpacing: (-0.35).sp,
);
