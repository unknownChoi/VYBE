import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';

class InfoRow extends StatelessWidget {
  final String icon;
  final String? text;
  final Widget? widget;
  final bool isLink;

  const InfoRow({
    required this.icon,
    this.text,
    this.widget,
    this.isLink = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: 16.w,
          colorFilter: const ColorFilter.mode(
            Color(0xFF535355),
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 12.w),
        if (widget != null)
          Expanded(child: widget!)
        else
          Expanded(
            child: Text(
              text!,
              style: isLink ? AppTextStyles.link : AppTextStyles.body,
            ),
          ),
      ],
    );
  }
}
