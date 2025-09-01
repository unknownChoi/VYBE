import 'package:flutter/material.dart';
import 'package:vybe/constants/appcolors.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/widgets/club_detail/club_layout.dart';
import 'package:vybe/widgets/club_detail/tabs.dart';

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
            ),
            MenuTab(
              categoryKeys: _categoryKeys,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
                _scrollToCategory(category);
              },
            ),
            const PhotoTab(),
            const ReviewTab(),
            const ClubInfoTab(),
          ],
        ),
      ),
    );
  }
}
