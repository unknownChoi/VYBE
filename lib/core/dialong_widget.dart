import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialongWidget extends StatefulWidget {
  const DialongWidget({super.key, required this.dialogWidget});

  final Widget dialogWidget;

  @override
  State<DialongWidget> createState() => _DialongWidgetState();
}

class _DialongWidgetState extends State<DialongWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 353.w,
      padding: EdgeInsets.only(
        top: 34.h,
        left: 34.w,
        right: 34.w,
        bottom: 18.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: widget.dialogWidget,
    );
  }
}
