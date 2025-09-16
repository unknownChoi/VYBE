// TODO: 바텀 네비게이터 아이콘

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';

class BottomNavIcon extends StatelessWidget {
  final String assetPath;
  final bool selected;

  const BottomNavIcon({
    super.key,
    required this.assetPath,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          assetPath,
          width: 24.w,
          color: selected ? AppColors.appGreenColor : Colors.white,
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}
