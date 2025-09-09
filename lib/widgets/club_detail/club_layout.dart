import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/constants/app_textstyles.dart';
import 'package:vybe/data/club_detail_mock_data.dart';

import '../../constants/appcolors.dart';
import 'common.dart';

class ClubHeader extends StatefulWidget {
  const ClubHeader({super.key});

  @override
  State<ClubHeader> createState() => _ClubHeaderState();
}

class _ClubHeaderState extends State<ClubHeader> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                items:
                    (clubData['coverImage'] as List<String>)
                        .map(
                          (item) => Image.asset(
                            item,
                            width: double.infinity,
                            height: 186.h,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  height: 186.h,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clubData['category']! as String,
                  style: AppTextStyles.subtitle,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      clubData['name']! as String,
                      style: AppTextStyles.title,
                    ),
                    const Spacer(),
                    const CallButton(),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children:
                      (clubData['tags'] as List<String>)
                          .map(
                            (tag) => Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Tag(text: tag),
                            ),
                          )
                          .toList(),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/club_detail_main/star.svg',
                      width: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      clubData['rating']! as String,
                      style: AppTextStyles.body,
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/club_detail_main/dot.svg',
                      width: 4.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "리뷰 ${clubData['reviews']! as String}",
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  clubData['description']! as String,
                  style: AppTextStyles.subtitle.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
              ],
            ),
          ),
          const CustomDivider(),
        ],
      ),
    );
  }
}

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
              SvgPicture.asset('assets/icons/club_detail_main/heart.svg'),
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
        color: AppColors.appBackgroundColor,
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
