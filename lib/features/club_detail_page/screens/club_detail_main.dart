import 'package:flutter/material.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/club_detail_page/widgets/layout/club_detail_bottom_bar.dart';
import 'package:vybe/features/club_detail_page/widgets/layout/club_header.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/club_info_tab.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/home_tab.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/menu_tab.dart';
import 'package:vybe/features/club_detail_page/widgets/tabs/photo_tab.dart';

import '../widgets/layout/sliver_tab_bar_delegate.dart';

import '../widgets/review_tab.dart';

class ClubDetailMain extends StatefulWidget {
  const ClubDetailMain({super.key});

  @override
  State<ClubDetailMain> createState() => _ClubDetailMainState();
}

class _ClubDetailMainState extends State<ClubDetailMain>
    with TickerProviderStateMixin {
  final Map<String, GlobalKey> _categoryKeys = {};
  String _selectedCategory = menuCategories.first;
  late final TabController _tabController;
  late final ScrollController _scrollController;
  final GlobalKey _menuTopKey = GlobalKey();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      bottomNavigationBar: const ClubDetailBottomBar(),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder:
            (context, _) => [
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
