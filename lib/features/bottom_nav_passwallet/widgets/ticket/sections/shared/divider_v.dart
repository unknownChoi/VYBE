import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DividerV extends StatelessWidget {
  const DividerV({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5.w,
      height: 40.h,
      color: const Color(0xFF707071),
    );
  }
}
