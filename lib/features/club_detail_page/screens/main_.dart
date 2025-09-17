// ========== merged: club_detail_main.dart + club_layout.dart + tabs.dart + components.dart + common.dart ==========

import 'package:flutter/material.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
// merged: remove local imports of club_layout.dart / tabs.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- from club_layout.dart imports ---
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

// keep original relative import as-is

// (common.dart was local; now merged - no import)

// --- from tabs.dart imports ---
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// (common/components were local; now merged - no import)

// --- from components.dart imports ---
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vybe/features/club_detail_page/utils/subway_utils.dart';

// import 'package:vybe/widgets/common/common.dart';

// --- from common.dart imports ---
import 'package:url_launcher/url_launcher.dart';

// ============================================================================
// club_detail_main.dart
// ============================================================================
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
            ReviewTab(),
            ClubInfoTab(),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// club_layout.dart
// ============================================================================
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
                  onPageChanged: (index, reason) {
                    setState(() => currentIndex = index);
                  },
                ),
              ),
              Positioned(
                left: 12.w,
                top: 50.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 9.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12.w,
                top: 45.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 9.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/club_detail/share.svg',
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 50.w,
                top: 50.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 9.h,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/icons/club_detail/heart.svg',
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 12.w,
                bottom: 12.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 9.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC191919),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${(clubData["coverImage"] as List).length}',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
                      'assets/icons/club_detail/star.svg',
                      width: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      clubData['rating']! as String,
                      style: AppTextStyles.body,
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/club_detail/dot.svg',
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

// ============================================================================
// tabs.dart
// ============================================================================
class HomeTab extends StatelessWidget {
  final TabController tabController;
  final ScrollController scrollController;
  final VoidCallback onSeeAllMenu;
  final VoidCallback onSeeAllPhoto;

  const HomeTab({
    required this.tabController,
    required this.scrollController,
    required this.onSeeAllMenu,
    required this.onSeeAllPhoto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubOverviewSection(clubData: clubData),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubSignatureSection(onSeeAll: onSeeAllMenu),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubImageArea(
              images: clubData['images']! as List<String>,
              onSeeAll: onSeeAllPhoto,
            ),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: const NearClubSection(),
          ),
          SizedBox(height: 118.h),
        ],
      ),
    );
  }
}

class MenuTab extends StatelessWidget {
  final Map<String, GlobalKey> categoryKeys;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final GlobalKey? topKey;

  const MenuTab({
    required this.categoryKeys,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.topKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          key: topKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubImageArea(
              images: clubData['menuImages']! as List<String>,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: CustomDivider()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100.h,
            child: Center(
              child: SizedBox(
                height: 35.h,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: menuCategories.length,
                  itemBuilder: (context, index) {
                    final category = menuCategories[index];
                    return GestureDetector(
                      onTap: () => onCategorySelected(category),
                      child: CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        ...menuItemsData.entries.expand((entry) {
          final category = entry.key;
          final items = entry.value;
          if (items.isEmpty) return <Widget>[];

          return [
            SliverToBoxAdapter(
              key: categoryKeys[category],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Text(category, style: AppTextStyles.sectionTitle),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: const Color(0xFF404042),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      MenuItemCard(
                        menuName: item["name"] as String,
                        menuPrice: item["price"] as int,
                        menuImageSrc: item["image"] as String,
                        isMainMenu: item["isMain"] as bool,
                      ),
                      Divider(
                        height: 1.h,
                        thickness: 1.h,
                        color: const Color(0xFF404042),
                      ),
                    ],
                  ),
                );
              }, childCount: items.length),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          ];
        }),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              '메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.',
              style: AppTextStyles.disclaimer,
            ),
          ),
        ),
      ],
    );
  }
}

class PhotoTab extends StatefulWidget {
  final GlobalKey? topKey;
  const PhotoTab({super.key, this.topKey});

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab>
    with AutomaticKeepAliveClientMixin<PhotoTab> {
  bool _isExpanded = false;
  final int _initialPhotoCount = 6;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final photosToShow =
        _isExpanded
            ? photoTabImageList
            : photoTabImageList.take(_initialPhotoCount).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          if (widget.topKey != null) SizedBox.shrink(key: widget.topKey),
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder:
                  //         (context) => PhotoViewerScreen(
                  //           imageUrls: photosToShow,
                  //           initialIndex: index,
                  //         ),
                  //   ),
                  // );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.asset(photosToShow[index], fit: BoxFit.cover),
                ),
              );
            },
            itemCount: photosToShow.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          if (photoTabImageList.length > _initialPhotoCount && !_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF404042)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      '사진 더보기',
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReviewTab extends StatefulWidget {
  const ReviewTab({super.key});

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  bool _isExpanded = false;
  final Set<int> _expandedContent = <int>{};

  @override
  Widget build(BuildContext context) {
    final reviewsToShow =
        _isExpanded ? reviewsData : reviewsData.take(5).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            itemCount: reviewsToShow.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final review = reviewsToShow[index];
              final String content = review['content'];
              final bool isLong = content.length > 70;
              final bool isContentExpanded = _expandedContent.contains(index);

              return ReviewCard(
                review: review,
                isExpandedContent: isContentExpanded,
                isLong: isLong,
                onToggle: () {
                  setState(() {
                    if (isContentExpanded) {
                      _expandedContent.remove(index);
                    } else {
                      _expandedContent.add(index);
                    }
                  });
                },
              );
            },
          ),
          if (reviewsData.length > 5 && !_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = true;
                  });
                },
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF404042)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      '리뷰 더보기 (${reviewsData.length - 5}개)',
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ClubInfoTab extends StatefulWidget {
  const ClubInfoTab({super.key});

  @override
  State<ClubInfoTab> createState() => _ClubInfoTabState();
}

class _ClubInfoTabState extends State<ClubInfoTab>
    with AutomaticKeepAliveClientMixin<ClubInfoTab> {
  NaverMapController? _mapController;
  NMarker? _marker;
  late final NCameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    final coords = clubData['addressCoords'] as Map<String, double>;
    final position = NLatLng(coords['x']!, coords['y']!);

    _initialCameraPosition = NCameraPosition(
      target: position,
      zoom: 16,
      bearing: 0,
      tilt: 0,
    );

    _loadMarker(position);
  }

  void _loadMarker(NLatLng position) async {
    final icon = NOverlayImage.fromAssetImage(
      'assets/images/common/map_location_pin.png',
    );

    _marker = NMarker(
      id: 'my-marker',
      position: position,
      icon: icon,
      size: NSize(20.w, 22.w),
    );

    if (_mapController != null) {
      _mapController!.addOverlay(_marker!);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final subwayInfo = clubData['subwayInfo'] as Map<String, dynamic>;
    final line = subwayInfo['line'] as String;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationSection(
            initialCameraPosition: _initialCameraPosition,
            marker: _marker,
            onMapReady: (controller) {
              _mapController = controller;
              if (_marker != null) {
                _mapController!.addOverlay(_marker!);
              }
            },
            subwayInfo: subwayInfo,
            line: line,
          ),
          const CustomDivider(),
          const DetailInfoSection(),
        ],
      ),
    );
  }
}

// ============================================================================
// components.dart
// ============================================================================
class ClubOverviewSection extends StatefulWidget {
  final Map<String, dynamic> clubData;

  const ClubOverviewSection({super.key, required this.clubData});

  @override
  State<ClubOverviewSection> createState() => _ClubOverviewSectionState();
}

class _ClubOverviewSectionState extends State<ClubOverviewSection> {
  bool _isBusinessHoursExpanded = false;

  @override
  Widget build(BuildContext context) {
    final clubData = widget.clubData;
    final subwayInfo = clubData['subwayInfo'] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: SvgPicture.asset('assets/icons/common/location_pin.svg'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          clubData['address'],
                          style: TextStyle(
                            color: const Color(0xFFD1C9C9),
                            fontSize: 16.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.12.h,
                            letterSpacing: -0.80.w,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (subwayInfo != null)
                        Container(
                          decoration: BoxDecoration(
                            color:
                                subwayLineColors[subwayInfo['line']] ??
                                const Color(0xFF9F9FA1),
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.0.w,
                            vertical: 2.0.h,
                          ),
                          child: Text(
                            subwayInfo['line']! as String,
                            style: AppTextStyles.stationNumber,
                          ),
                        ),
                      SizedBox(width: 8.0.w),
                      Text(
                        "${subwayInfo!['station']} ${subwayInfo['exitNum']}번 출구에서 ${subwayInfo['distance']}",
                        style: TextStyle(
                          color: const Color(0xFFD1C9C9),
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.12.h,
                          letterSpacing: -0.80,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: SvgPicture.asset('assets/icons/club_detail/time.svg'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _isBusinessHoursExpanded = !_isBusinessHoursExpanded;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          "영업중",
                          style: TextStyle(
                            color: const Color(0xFFECECEC),
                            fontSize: 16.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.12.h,
                            letterSpacing: -0.80,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        SvgPicture.asset('assets/icons/club_detail/dot.svg'),
                        SizedBox(width: 4.w),
                        Text(
                          "02:00에 영업종료",
                          style: TextStyle(
                            color: const Color(0xFFECECEC),
                            fontSize: 16.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.12.h,
                            letterSpacing: -0.80,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        SvgPicture.asset(
                          _isBusinessHoursExpanded
                              ? 'assets/icons/club_detail/arrow_up.svg'
                              : 'assets/icons/club_detail/arrow_down.svg',
                        ),
                      ],
                    ),
                  ),
                  if (_isBusinessHoursExpanded)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            businessHours.map((entry) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        entry['day']!,
                                        style: TextStyle(
                                          color: const Color(0xFFCACACB),
                                          fontSize: 14.sp,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.14.h,
                                          letterSpacing: -0.70,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    SvgPicture.asset(
                                      'assets/icons/club_detail/dot.svg',
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      entry['hours']!,
                                      style: TextStyle(
                                        color: const Color(0xFFCACACB),
                                        fontSize: 14.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 1.14.h,
                                        letterSpacing: -0.70,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            SvgPicture.asset('assets/icons/club_detail/entry_fee.svg'),
            SizedBox(width: 12.w),
            Text(
              clubData['entryFee'],
              style: TextStyle(
                color: const Color(0xFFECECEC),
                fontSize: 16.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.12.h,
                letterSpacing: -0.80,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            SvgPicture.asset('assets/icons/club_detail/contect.svg'),
            SizedBox(width: 12.w),
            Text(
              clubData['instagramUrl'],
              style: TextStyle(
                color: const Color(0xFF2B6AFF),
                fontSize: 16.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.12.h,
                letterSpacing: -0.80,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ClubSignatureSection extends StatefulWidget {
  final VoidCallback? onSeeAll;

  const ClubSignatureSection({super.key, this.onSeeAll});

  @override
  State<ClubSignatureSection> createState() => _ClubSignatureSectionState();
}

class _ClubSignatureSectionState extends State<ClubSignatureSection> {
  late final List<Map<String, dynamic>> _mainMenuItems;

  @override
  void initState() {
    super.initState();
    _mainMenuItems = menuItemsData.values
        .expand((menuList) => menuList)
        .where((item) => item['isMain'] as bool)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final mainMenuItems = _mainMenuItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("메뉴", style: AppTextStyles.sectionTitle),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("전체보기", style: AppTextStyles.seeAll),
                  SizedBox(width: 4.w),
                  SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(thickness: 1.h, color: const Color(0xFF404042)),
        ...mainMenuItems.expand((item) {
          return [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: MenuItemCard(
                menuName: item['name'] as String,
                menuPrice: item['price'] as int,
                menuImageSrc: item['image'] as String,
                isMainMenu: item['isMain'] as bool,
              ),
            ),
            Divider(thickness: 1.h, color: const Color(0xFF404042)),
          ];
        }),
        Text(
          '메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.',
          style: TextStyle(
            color: const Color(0xFF9F9FA1),
            fontSize: 12.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.17.h,
            letterSpacing: -0.30.w,
          ),
        ),
      ],
    );
  }
}

class ClubImageArea extends StatelessWidget {
  final List<String> images;
  final VoidCallback? onSeeAll;
  const ClubImageArea({super.key, required this.images, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("사진", style: AppTextStyles.sectionTitle),
            SizedBox(width: 8.w),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('전체보기', style: AppTextStyles.seeAll),
                  SizedBox(width: 4.w),
                  SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final imagePath in images)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      imagePath,
                      width: 165.w,
                      height: 110.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class NearClubSection extends StatelessWidget {
  const NearClubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("주변 클럽", style: AppTextStyles.sectionTitle),
            Spacer(),
            Text("전체 보기", style: AppTextStyles.seeAll),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
          ],
        ),
        SizedBox(height: 24.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_1.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_2.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_3.png",
              ),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_1.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_2.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_3.png",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final bool isExpandedContent;
  final bool isLong;
  final VoidCallback onToggle;

  const ReviewCard({
    super.key,
    required this.review,
    required this.isExpandedContent,
    required this.isLong,
    required this.onToggle,
  });

  String _truncate(String text, {int max = 50}) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    final String author = review['author'];
    final String rating = review['rating'];
    final String date = review['date'];
    final String content = review['content'];
    final List<String> imageUrls =
        (review['imageUrls'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final String displayContent =
        (!isLong || isExpandedContent) ? content : _truncate(content);

    return Container(
      constraints: BoxConstraints(minHeight: 140.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFF2F2F33), width: 1.h),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 작성자, 별점, 날짜
          Row(
            children: [
              Text(
                author,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.14.h,
                  letterSpacing: -0.35,
                ),
              ),
              SizedBox(width: 8.w),
              SvgPicture.asset('assets/icons/club_detail/star.svg'),
              SizedBox(width: 4.w),
              Text(
                rating,
                style: TextStyle(
                  color: Color(0xFFECECEC),
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.12.h,
                  letterSpacing: -0.80,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: TextStyle(
                  color: Color(0xFFCACACB),
                  fontSize: 12.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.17.h,
                  letterSpacing: -0.30,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          /// 본문 + 이미지
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 본문
              SizedBox(
                width:
                    imageUrls.isNotEmpty && imageUrls.first.isNotEmpty
                        ? 239.w
                        : 345.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayContent,
                      style: TextStyle(
                        color: Color(0xFFECECEC),
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.12.h,
                        letterSpacing: -0.80,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (isLong)
                      GestureDetector(
                        onTap: onToggle,
                        child: Row(
                          children: [
                            Text(
                              isExpandedContent ? '접기' : '자세히 보기',
                              style: TextStyle(
                                color: const Color(0xFF9F9FA1),
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.17.h,
                                letterSpacing: -0.30,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset(
                              width: 8.w,
                              isExpandedContent
                                  ? 'assets/icons/club_detail/arrow_up.svg'
                                  : 'assets/icons/club_detail/arrow_down.svg',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(),

              /// 이미지 (있을 때만 표시)
              if (imageUrls.isNotEmpty && imageUrls.first.isNotEmpty)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      imageUrls.first,
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.cover,
                    ),

                    /// 여러 장일 경우 +N 뱃지
                    if (imageUrls.length > 1)
                      Positioned(
                        bottom: 6.h,
                        right: 6.w,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: const BoxDecoration(
                            color: Color(0xCC191919),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${imageUrls.length - 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class LocationSection extends StatelessWidget {
  final NCameraPosition initialCameraPosition;
  final NMarker? marker;
  final ValueChanged<NaverMapController> onMapReady;
  final Map<String, dynamic> subwayInfo;
  final String line;

  const LocationSection({
    super.key,
    required this.initialCameraPosition,
    required this.marker,
    required this.onMapReady,
    required this.subwayInfo,
    required this.line,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('위치', style: AppTextStyles.sectionTitle),
          SizedBox(height: 24.h),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 172.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: initialCameraPosition,
                ),
                onMapReady: onMapReady,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          InfoRow(
            icon: 'assets/icons/common/location_pin.svg',
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      clubData['address']! as String,
                      style: TextStyle(
                        color: const Color(0xFFD1C9C9),
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 1.12.h,
                        letterSpacing: -0.80,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: clubData['address']! as String),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('주소가 복사되었습니다.')),
                        );
                      },
                      child: Icon(
                        Icons.copy_outlined,
                        color: const Color(0xFF9F9FA1),
                        size: 14.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Container(
                      width: 18.w,
                      height: 18.w,
                      decoration: BoxDecoration(
                        color: subwayLineColors[subwayInfo['line']],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(line, style: AppTextStyles.stationNumber),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${subwayInfo['station']} ${subwayInfo['exitNum']}번 출구에서 ${subwayInfo['distance']}',
                      style: TextStyle(
                        color: const Color(0xFFD1C9C9),
                        fontSize: 16.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 1.12.h,
                        letterSpacing: -0.80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailInfoSection extends StatelessWidget {
  const DetailInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상세 정보', style: AppTextStyles.sectionTitle),
          SizedBox(height: 24.h),
          _buildInfoItem(
            '전화번호',
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/club_detail/phone.svg',
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  clubData['phoneNumber']! as String,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
              ],
            ),
          ),
          _buildInfoItem(
            '안내 및 유의사항',
            Text(
              clubData['guidelines']! as String,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xFFCACACB),
              ),
            ),
          ),
          _buildInfoItem(
            '영업 시간',
            Text(
              clubData['businessHoursSummary']! as String,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xFFD1C9C9),
              ),
            ),
          ),
          _buildInfoItem(
            '오픈 채팅',
            Text(
              clubData['openChatLink']! as String,
              style: AppTextStyles.link,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, Widget content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(color: const Color(0xFFCACACB)),
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }
}

// ============================================================================
// common.dart
// ============================================================================
class InfoRow extends StatelessWidget {
  final String icon;
  final String? text;
  final Widget? widget;
  final bool isLink;

  const InfoRow({
    required this.icon,
    this.text,
    this.widget,
    this.isLink = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon,
          width: 16.w,
          colorFilter: const ColorFilter.mode(
            Color(0xFF535355),
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 12.w),
        if (widget != null)
          Expanded(child: widget!)
        else
          Expanded(
            child: Text(
              text!,
              style: isLink ? AppTextStyles.link : AppTextStyles.body,
            ),
          ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    required this.title,
    this.showSeeAll = true,
    this.onSeeAllTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (showSeeAll) ...[
          const Spacer(),
          GestureDetector(
            onTap: onSeeAllTap ?? () {},
            child: Row(
              children: [
                Text("전체보기", style: AppTextStyles.seeAll),
                SizedBox(width: 4.w),
                SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8.h,
      color: const Color(0xFF2F2F33),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String menuName;
  final int menuPrice;
  final String menuImageSrc;
  final bool isMainMenu;

  const MenuItemCard({
    required this.menuName,
    required this.menuPrice,
    required this.menuImageSrc,
    required this.isMainMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 124.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    if (isMainMenu)
                      Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.appPurpleColor,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            "대표",
                            style: AppTextStyles.representative,
                          ),
                        ),
                      ),
                    Text(menuName, style: AppTextStyles.body),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  '${_wonFormat.format(menuPrice)}원',
                  style: AppTextStyles.price,
                ),
              ],
            ),
            if (menuImageSrc.isNotEmpty) ...[
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  menuImageSrc,
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final NumberFormat _wonFormat = NumberFormat('#,###');

class Tag extends StatelessWidget {
  final String text;
  const Tag({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: const Color(0xFF2F2F33),
      ),
      child: Center(child: Text(text, style: AppTextStyles.tag)),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;

  const CategoryChip({
    required this.category,
    required this.isSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.appPurpleColor : Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          width: 1.w,
          color:
              isSelected ? AppColors.appPurpleColor : const Color(0xFF404042),
        ),
      ),
      child: Center(child: Text(category, style: AppTextStyles.category)),
    );
  }
}

class CallButton extends StatelessWidget {
  const CallButton({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('전화 앱을 열 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _makePhoneCall('010 5909195');
        print("de");
      },
      child: Container(
        width: 60.w,
        height: 26.h,
        decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: const Color(0xFF9F9FA1)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/icons/club_detail/call.svg', width: 14.w),
            Text("전화", style: AppTextStyles.callButtonText),
          ],
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final bool outlined;

  const ActionButton({required this.text, this.outlined = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : AppColors.appPurpleColor,
        border:
            outlined
                ? Border.all(color: AppColors.appPurpleColor, width: 1.w)
                : null,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Center(child: Text(text, style: AppTextStyles.actionButton)),
    );
  }
}

class NearClubCard extends StatelessWidget {
  final String clubName;
  final String clubCity;
  final String clubType;
  final String clubImageSrc;

  const NearClubCard({
    super.key,
    required this.clubName,
    required this.clubCity,
    required this.clubType,
    required this.clubImageSrc,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(clubImageSrc),
        SizedBox(height: 8.h),
        Text(
          clubName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            height: 1.14.h,
            letterSpacing: -0.70,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              clubCity,
              style: TextStyle(
                color: const Color(0xFF9F9FA1),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.17.h,
                letterSpacing: -0.30,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/icons/club_detail/dot.svg'),
            SizedBox(width: 4.w),
            Text(
              clubType,
              style: TextStyle(
                color: const Color(0xFF9F9FA1),
                fontSize: 12.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.17.h,
                letterSpacing: -0.30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
