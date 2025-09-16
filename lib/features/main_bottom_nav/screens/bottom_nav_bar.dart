// TODO: 바텀 네비게이터 

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/main_bottom_nav/widgets/bottom_nav_icon.dart';
import 'package:vybe/features/main_bottom_nav/widgets/main_tab_config.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        height: 95.h,
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF2F2F33), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: AppColors.appBackgroundColor,
          selectedItemColor: AppColors.appGreenColor,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: bottomNavSelectedLabelStyle,
          unselectedLabelStyle: bottomNavUnselectedLabelStyle,
          type: BottomNavigationBarType.fixed,
          items: [
            for (int i = 0; i < mainTabs.length; i++)
              BottomNavigationBarItem(
                icon: BottomNavIcon(
                  assetPath: mainTabs[i].iconAsset,
                  selected: i == currentIndex,
                ),
                label: mainTabs[i].label,
              ),
          ],
          onTap: onTap,
        ),
      ),
    );
  }
}

// 기존 스타일
const TextStyle bottomNavSelectedLabelStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  height: 1.17,
  letterSpacing: -0.30,
);

const TextStyle bottomNavUnselectedLabelStyle = TextStyle(
  color: AppColors.appGreenColor,
  fontSize: 12,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  height: 1.17,
  letterSpacing: -0.30,
);
