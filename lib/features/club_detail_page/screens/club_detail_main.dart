import 'package:flutter/material.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/club_detail_page/widgets/layout/club_detail_bottom_bar.dart';
import 'package:vybe/features/club_detail_page/widgets/layout/club_header.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/club_info_tab.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/home_tab.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/menu_tab.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/photo_tab.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/review_tab.dart';

import '../widgets/layout/sliver_tab_bar_delegate.dart';

class ClubDetailMain extends StatefulWidget {
  const ClubDetailMain({super.key});

  @override
  State<ClubDetailMain> createState() => _ClubDetailMainState();
}

class _ClubDetailMainState extends State<ClubDetailMain>
    with TickerProviderStateMixin {
  // 카테고리별로 스크롤 위치를 찾기 위해 저장해 두는 GlobalKey 맵
  final Map<String, GlobalKey> _categoryKeys = {};
  // 현재 선택된 메뉴 카테고리
  String _selectedCategory = menuCategories.first;
  // 상단 탭 전환을 제어하는 컨트롤러
  late final TabController _tabController;
  // 전체 NestedScrollView 스크롤을 제어하는 컨트롤러
  late final ScrollController _scrollController;
  // 메뉴 탭 최상단 위치를 가리키는 키
  final GlobalKey _menuTopKey = GlobalKey();
  // 사진 탭 최상단 위치를 가리키는 키
  final GlobalKey _photoTopKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController = ScrollController();
    for (final category in menuCategories) {
      _categoryKeys[category] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 특정 카테고리가 보이도록 스크롤 위치를 이동
  void _scrollToCategory(String category) {
    final key = _categoryKeys[category];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  // 홈 탭에서 "모두 보기" 시 메뉴 탭 최상단으로 이동
  void _goToMenuTop() {
    _tabController.animateTo(1);
    Future.delayed(const Duration(milliseconds: 250), () {
      final ctx = _menuTopKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: 0.0,
        );
      }
    });
  }

  // 홈 탭에서 "모두 보기" 시 사진 탭 최상단으로 이동
  void _goToPhotoTop() {
    _tabController.animateTo(2);
    Future.delayed(const Duration(milliseconds: 250), () {
      final ctx = _photoTopKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          alignment: 0.0,
        );
      }
    });
  }

  @override
  // 전체 클럽 상세 페이지 레이아웃과 탭 구성을 그리는 메서드
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      bottomNavigationBar: ClubDetailBottomBar(
        clubName: ((clubData['name']) as String?) ?? '',
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, _) => [
          const ClubHeader(),
          ClubDetailSliverTabBar(controller: _tabController),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeTab(
              tabController: _tabController,
              scrollController: _scrollController,
              onSeeAllMenu: _goToMenuTop,
              onSeeAllPhoto: _goToPhotoTop,
            ),
            MenuTab(
              categoryKeys: _categoryKeys,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
                _scrollToCategory(category);
              },
              topKey: _menuTopKey,
            ),
            PhotoTab(topKey: _photoTopKey),
            const ReviewTab(),
            const ClubInfoTab(),
          ],
        ),
      ),
    );
  }
}
