import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/club_detail_page/widgets/action_button.dart';

class ClubDetailBottomBar extends StatelessWidget {
  const ClubDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      height: 92.h,
      color: const Color(0xFF1B1B1D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/club_detail/heart.svg'),
              SizedBox(height: 2.h),
              Text('000', style: AppTextStyles.bottomBarText),
            ],
          ),
          SizedBox(width: 15.w),
          const ActionButton(text: '웨이팅 등록', outlined: true),
          SizedBox(width: 8.w),
          const ActionButton(text: '테이블 예약'),
        ],
      ),
    );
  }
}
