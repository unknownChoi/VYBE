// lib/widgets/auth/ui02_birth_input.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/auth/utils/login_02_validators.dart';

class Login02Birthinput extends StatefulWidget {
  final TextEditingController frontController;
  final TextEditingController backController;
  final FocusNode? frontFocus;
  final FocusNode? backFocus;

  const Login02Birthinput({
    super.key,
    required this.frontController,
    required this.backController,
    this.frontFocus,
    this.backFocus,
  });

  @override
  State<Login02Birthinput> createState() => _Ui02BirthInputState();
}

class _Ui02BirthInputState extends State<Login02Birthinput> {
  FocusNode? _internalFrontFocus;
  FocusNode? _internalBackFocus;

  FocusNode get _frontFocus {
    if (widget.frontFocus != null) return widget.frontFocus!;
    _internalFrontFocus ??= FocusNode();
    return _internalFrontFocus!;
  }

  FocusNode get _backFocus {
    if (widget.backFocus != null) return widget.backFocus!;
    _internalBackFocus ??= FocusNode();
    return _internalBackFocus!;
  }

  @override
  void initState() {
    super.initState();
    widget.frontController.addListener(_handleFrontInput);
    widget.backController.addListener(_handleBackInput);
  }

  void _handleFrontInput() => setState(() {});
  void _handleBackInput() => setState(() {});

  @override
  void dispose() {
    _internalFrontFocus?.dispose();
    _internalBackFocus?.dispose();
    widget.frontController.removeListener(_handleFrontInput);
    widget.backController.removeListener(_handleBackInput);
    super.dispose();
  }

  InputDecoration get _inputDecoration =>
      const InputDecoration(border: InputBorder.none, counterText: '');

  @override
  Widget build(BuildContext context) {
    const String fixedDots = '●●●●●●';
    final String frontText = widget.frontController.text;
    final String backText = widget.backController.text;
    final bool hasInput = frontText.isNotEmpty || backText.isNotEmpty;
    final bool invalidBirth =
        frontText.length == 6 && backText.isNotEmpty
            ? isInvalidBirthYearUi02(frontText, backText[0])
            : false;
    final Color containerColor =
        invalidBirth
            ? Colors.red
            : hasInput
            ? AppColors.appPurpleColor
            : Colors.white;
    final Color textColor = invalidBirth ? Colors.red : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "주민등록번호",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: widget.frontController,
                  focusNode: _frontFocus,
                  maxLength: 6,
                  decoration: _inputDecoration,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24.sp,
                    letterSpacing: 8.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: Colors.white,
                ),
              ),
              Text("-", style: TextStyle(color: textColor, fontSize: 24.sp)),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: widget.backController,
                      focusNode: _backFocus,
                      maxLength: 1,
                      decoration: _inputDecoration,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 24.sp,
                        letterSpacing: 8.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: Colors.white,
                    ),
                    IgnorePointer(
                      child: Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Text(
                          fixedDots,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13.sp,
                            letterSpacing: 8.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(width: double.infinity, height: 2.h, color: containerColor),
      ],
    );
  }
}
