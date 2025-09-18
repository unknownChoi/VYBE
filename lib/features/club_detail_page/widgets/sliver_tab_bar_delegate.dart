import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class ClubDetailSliverTabBar extends StatelessWidget {
  final TabController controller;
  const ClubDetailSliverTabBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverTabBarDelegate(
        TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: AppColors.appPurpleColor,
          indicatorWeight: 3.h,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFFCACACB),
          labelStyle: AppTextStyles.tabSelected,
          unselectedLabelStyle: AppTextStyles.tabUnselected,
          tabs: const [
            Tab(text: "홈"),
            Tab(text: "메뉴"),
            Tab(text: "사진"),
            Tab(text: "리뷰"),
            Tab(text: "매장 정보"),
          ],
        ),
      ),
    );
  }
}

class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E10),
        border: Border(
          bottom: BorderSide(color: const Color(0xFF4A4A4A), width: 2.h),
        ),
      ),
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) => false;
}
