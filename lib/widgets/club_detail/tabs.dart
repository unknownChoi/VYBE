import 'package:flutter/material.dart';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:vybe/constants/app_textstyles.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/screens/photo_viewer_screen.dart';

import 'package:vybe/widgets/club_detail/common.dart';
import 'package:vybe/widgets/club_detail/components.dart';

/// 홈 탭
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

/// 메뉴 탭
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

/// 사진 탭
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PhotoViewerScreen(
                            imageUrls: photosToShow,
                            initialIndex: index,
                          ),
                    ),
                  );
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

/// 리뷰 탭
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

/// 클럽 정보 탭
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
      'assets/images/map_location_pin.png',
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
