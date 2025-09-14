// lib/widgets/auth/ui02_input_fields.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/auth/utils/ui02_phone_formatter.dart';

class Login02Inputfield extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FocusNode? focusNode;

  const Login02Inputfield({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.focusNode,
  });

  @override
  State<Login02Inputfield> createState() => _Ui02NameInputFieldState();
}

class _Ui02NameInputFieldState extends State<Login02Inputfield> {
  bool get _hasText => widget.controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _hasText ? AppColors.appPurpleColor : Colors.white;
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: "이름을 입력해주세요.",
          hintStyle: TextStyle(
            color: Color(0xFF707071),
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.60.sp,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.w),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.w),
          ),
        ),
      ),
    );
  }
}

class Ui02PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final FocusNode? focusNode;

  const Ui02PhoneInputField({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.focusNode,
  });

  @override
  State<Ui02PhoneInputField> createState() => _Ui02PhoneInputFieldState();
}

class _Ui02PhoneInputFieldState extends State<Ui02PhoneInputField> {
  bool get _hasText => widget.controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChange);
  }

  void _onChange() => setState(() {});

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _hasText ? AppColors.appPurpleColor : Colors.white;

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        inputFormatters: [PhoneNumberInputFormatter()],
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.60.sp,
        ),
        decoration: InputDecoration(
          hintText: "010-0000-0000",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 24.sp),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.w),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.w),
          ),
        ),
      ),
    );
  }
}

class Ui02LabeledInputField extends StatelessWidget {
  final String label;
  final Widget child;
  const Ui02LabeledInputField({
    required this.label,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8.h),
      child,
    ],
  );
}

class Ui02AnimatedInputField extends StatelessWidget {
  final bool visible;
  final Widget child;

  const Ui02AnimatedInputField({
    super.key,
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
    opacity: visible ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 300),
    child: AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: visible ? Offset.zero : Offset(0, 0.2.h),
      child: child,
    ),
  );
}
