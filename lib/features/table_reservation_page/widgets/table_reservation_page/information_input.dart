import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

/// 예약자명/연락처 입력 필드.
class InformationInput extends StatelessWidget {
  const InformationInput({
    super.key,
    required this.inputTitle,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.isFilled,
    this.inputFormatters,
  });

  final String inputTitle;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool isFilled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        isFilled ? AppColors.appPurpleColor : const Color(0xFF2F2F33);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          inputTitle,
          style: TextStyle(
            color: const Color(0xFFECECEC),
            fontSize: 16.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.25,
            letterSpacing: -0.80,
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity,
          height: 40.h,
          child: TextField(
            controller: controller,
            keyboardType:
                inputTitle == '예약자명' ? TextInputType.name : TextInputType.phone,
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFCACACB),
                fontSize: 14.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.14,
                letterSpacing: -0.70,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: BorderSide(color: borderColor, width: 1),
              ),
            ),
            style: TextStyle(
              color: const Color(0xFFCACACB),
              fontSize: 14.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.14,
              letterSpacing: -0.70,
            ),
          ),
        ),
      ],
    );
  }
}

/// 연락처 입력 시 자동 하이픈 처리 포맷터.
class HyphenPhoneFormatter extends TextInputFormatter {
  const HyphenPhoneFormatter();

  static const int _maxDigits = 11;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
        composing: TextRange.empty,
      );
    }

    final truncated = digitsOnly.length > _maxDigits
        ? digitsOnly.substring(0, _maxDigits)
        : digitsOnly;

    final buffer = StringBuffer();
    final length = truncated.length;

    if (length <= 3) {
      buffer.write(truncated);
    } else if (length <= 6) {
      buffer
        ..write(truncated.substring(0, 3))
        ..write('-')
        ..write(truncated.substring(3));
    } else if (length <= 10) {
      buffer
        ..write(truncated.substring(0, 3))
        ..write('-')
        ..write(truncated.substring(3, 6))
        ..write('-')
        ..write(truncated.substring(6));
    } else {
      buffer
        ..write(truncated.substring(0, 3))
        ..write('-')
        ..write(truncated.substring(3, 7))
        ..write('-')
        ..write(truncated.substring(7));
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
      composing: TextRange.empty,
    );
  }
}
