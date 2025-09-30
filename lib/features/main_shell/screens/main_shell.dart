// TODO: 바텀 네비게이터 메인 뷰

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/main_bottom_nav/screens/bottom_nav_bar.dart';
import 'package:vybe/features/bottom_nav_home/screens/home_tab_screen.dart';
import 'package:vybe/features/bottom_nav_home/models/feature_item.dart';
import 'package:vybe/features/bottom_nav_near/screens/near_tab_screen.dart';
import 'package:vybe/features/bottom_nav_passwallet/screens/passwallet_tab_screen.dart';
import 'package:vybe/features/bottom_nav_search/screens/search_tab_screen.dart';
import 'package:vybe/features/bottom_nav_mypage/screens/mypage_tab_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<String> banners = const [
    'assets/images/bottom_nav_home/banner_1.png',
    'assets/images/bottom_nav_home/banner_2.png',
    'assets/images/bottom_nav_home/banner_3.png',
  ];

  final List<FeatureItem> featureItems = const [
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_1.svg',
      label: 'VYBE 추천',
    ),
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_2.svg',
      label: '핫플레이스',
    ),
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_3.svg',
      label: '입장료 무료',
    ),
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_4.svg',
      label: '서비스 음료',
    ),
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_5.svg',
      label: '힙합',
    ),
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_6.svg',
      label: 'EDM',
    ),
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_7.svg',
      label: 'K-POP',
    ),
    FeatureItem(
      iconPath: 'assets/icons/bottom_nav_home/middle_button_8.svg',
      label: '라운지',
    ),
  ];

  PreferredSizeWidget? get _appBar {
    if (_index != 0) return null;
    return AppBar(
      backgroundColor: AppColors.appBackgroundColor,
      elevation: 0,
      leadingWidth: 130.w,
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Image.asset(
          'assets/images/common/main_logo.png',
          fit: BoxFit.contain,
          height: 44.h,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => setState(() => _index = 3),
          child: SvgPicture.asset('assets/icons/bottom_nav_home/search.svg'),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: () {},
          child: SvgPicture.asset(
            'assets/icons/bottom_nav_home/notifications_none.svg',
          ),
        ),
        SizedBox(width: 24.w),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTabScreen(banners: banners, featureItems: featureItems),
      const NearTabScreen(),
      const PasswalletTabScreen(),
      SearchTabScreen(),
      const MyPageTabScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: _appBar,
      body: pages[_index],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
