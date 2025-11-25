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
import 'package:vybe/services/firebase/firebase_service.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  List<String> _banners = const [];
  bool _isLoadingBanners = true;

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
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _loadBannersFromStorage();
  }

  Future<void> _loadBannersFromStorage() async {
    try {
      final urls = await FirebaseService.fetchHomeBannerImages();
      if (!mounted) return;
      setState(() {
        _banners = urls;
        _isLoadingBanners = false;
      });
    } catch (e) {
      // Storage에서 배너를 불러오지 못하면 빈 상태를 유지한다.
      debugPrint('Failed to load banners from storage: $e');
      if (mounted) {
        setState(() => _isLoadingBanners = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTabScreen(
        banners: _banners,
        featureItems: featureItems,
        isLoadingBanners: _isLoadingBanners,
      ),
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
