import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/constants/app_textstyles.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/screens/photo_viewer_screen.dart';
import 'package:vybe/widgets/club_detail/common.dart';
import 'package:vybe/widgets/club_detail/components.dart';

class HomeTab extends StatelessWidget {
  final TabController tabController;
  final ScrollController scrollController;
  const HomeTab({
    required this.tabController,
    required this.scrollController,
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
            child: ClubSignatureSection(),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubImageArea(
              images: clubData['images']! as List<String>,
              // onSeeAllTap: () {
              //   tabController.animateTo(2); // 2 is the index for PhotoTab
              //   if (scrollController.hasClients) {
              //     scrollController.animateTo(
              //       0,
              //       duration: const Duration(milliseconds: 300),
              //       curve: Curves.easeOut,
              //     );
              //   }
              // },
            ),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: NearClubSection(),
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

  const MenuTab({
    required this.categoryKeys,
    required this.selectedCategory,
    required this.onCategorySelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        // SliverToBoxAdapter(
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        //     child: ClubImageArea(
        //       title: '메뉴 이미지',
        //       images: clubData['menuImages']! as List<String>,
        //       showSeeAll: false,
        //     ),
        //   ),
        // ),
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
  const PhotoTab({super.key});

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab> {
  bool _isExpanded = false;
  final int _initialPhotoCount = 6;

  @override
  Widget build(BuildContext context) {
    final photosToShow =
        _isExpanded
            ? photoTabImageList
            : photoTabImageList.take(_initialPhotoCount).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
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
                  child: Image.asset(photosToShow[index], fit: BoxFit.contain),
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

  @override
  Widget build(BuildContext context) {
    final reviewsToShow =
        _isExpanded ? reviewsData : reviewsData.take(5).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            itemCount: reviewsToShow.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Text('good');
              return null;
            },
            separatorBuilder:
                (context, index) =>
                    Divider(color: const Color(0xFF2F2F33), height: 16.h),
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
    final icon = NOverlayImage.fromAssetImage('assets/images/test_image.png');

    _marker = NMarker(
      id: 'my-marker',
      position: position,
      icon: icon,
      size: const NSize(48, 48),
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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                        initialCameraPosition: _initialCameraPosition,
                      ),
                      onMapReady: (controller) {
                        _mapController = controller;
                        if (_marker != null) {
                          _mapController!.addOverlay(_marker!);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                InfoRow(
                  icon: 'assets/icons/club_detail_main/location_pin.svg',
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              clubData['address']! as String,
                              style: AppTextStyles.body.copyWith(
                                color: const Color(0xFFD1C9C9),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: clubData['address']! as String,
                                ),
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
                            decoration: const BoxDecoration(
                              color: Color(0xFFBD941C),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "9",
                                style: AppTextStyles.stationNumber,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // Text(
                          //   clubData['distance']! as String,
                          //   style: AppTextStyles.body.copyWith(
                          //     color: const Color(0xFFD1C9C9),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const CustomDivider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('상세 정보', style: AppTextStyles.sectionTitle),
                SizedBox(height: 24.h),
                Text(
                  '전화번호',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/club_detail_main/phone.svg'),
                    SizedBox(width: 8.w),
                    Text(
                      clubData['phoneNumber']! as String,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.body.copyWith(
                        color: const Color(0xFFCACACB),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  '안내 및 유의사항',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  clubData['guidelines']! as String,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  '영업 시간',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  clubData['businessHoursSummary']! as String,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFD1C9C9),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  '오픈 채팅',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  clubData['openChatLink']! as String,
                  style: AppTextStyles.link,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
