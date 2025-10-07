import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MetricItem extends StatelessWidget {
  const MetricItem({
    super.key,
    required this.title,
    required this.value,
    required this.titleStyle,
    required this.valueStyle,
  });
  final String title;
  final String value;
  final TextStyle titleStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 118.w,
      child: Column(
        children: [
          Text(title, textAlign: TextAlign.center, style: titleStyle),
          SizedBox(height: 10.h),
          Text(value, textAlign: TextAlign.center, style: valueStyle),
        ],
      ),
    );
  }
}
