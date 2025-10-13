// TODO: 바텀 네비게이터 홈 탭

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/widgets/near_club_card.dart';
import 'package:vybe/features/club_detail_page/screens/club_detail_main.dart';
import 'package:vybe/services/firebase/firebase_service.dart';

import '../models/feature_item.dart';
import '../widgets/feature_grid_item.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({
    super.key,
    required this.banners,
    required this.featureItems,
  });

  final List<String> banners;
  final List<FeatureItem> featureItems;

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  List<String> nearClubImageUrls = [];
  bool isLoadingNearClub = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final urls = await FirebaseService.fetchNearClubImages();
    if (!mounted) return;
    setState(() {
      nearClubImageUrls = urls;
      isLoadingNearClub = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ==== 기존 MainPage 의 build 내용 그대로 (Scaffold 없이) ====
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(height: 13.h),
          SizedBox(
            width: 1.sw,
            height: 18.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/common/location_pin.svg'),
                  SizedBox(width: 4.w),
                  Text(
                    "내 주변 검색",
                    style: TextStyle(
                      color: Color(0xFFECECEC),
                      fontSize: 16.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.12,
                      letterSpacing: -0.80.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          CarouselSlider(
            options: CarouselOptions(
              height: 228.h,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
            ),
            items: widget.banners
                .map(
                  (banner) => Image.asset(
                    banner,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 24.w,
                crossAxisSpacing: 24.w,
                childAspectRatio: 0.8,
              ),
              itemCount: widget.featureItems.length,
              itemBuilder: (context, index) {
                final item = widget.featureItems[index];
                return FeatureGridItem(
                  item: item,
                  isVybe: index == 0,
                  onTap: () => print('Clicked: ${item.label}'),
                );
              },
            ),
          ),
          SizedBox(height: 32.h),
          Container(width: 1.sw, height: 8.h, color: const Color(0xFF2F2F33)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "주변 클럽",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.10,
                          letterSpacing: -0.50.sp,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "전체보기",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFCACACB),
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.17,
                            letterSpacing: -0.30.sp,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          'assets/icons/bottom_nav_home/showinfo_icon.svg',
                          width: 4.sp,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 새 화면으로 이동 (스택에 push)
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => ClubDetailMain()),
                          );
                        },
                        child: const NearClubCard(
                          clubName: "클럽 레이저",
                          clubType: "힙합",
                          clubCity: "홍대",
                          clubImageSrc: "assets/images/test_image/test_2.png",
                        ),
                      ),
                      SizedBox(width: 12.w),
                      const NearClubCard(
                        clubName: "클럽 레이저",
                        clubType: "힙합",
                        clubCity: "홍대",
                        clubImageSrc: "assets/images/test_image/test_3.png",
                      ),
                      SizedBox(width: 12.w),
                      const NearClubCard(
                        clubName: "클럽 레이저",
                        clubType: "힙합",
                        clubCity: "홍대",
                        clubImageSrc: "assets/images/test_image/test_1.png",
                      ),
                      SizedBox(width: 12.w),
                      const NearClubCard(
                        clubName: "클럽 레이저",
                        clubType: "힙합",
                        clubCity: "홍대",
                        clubImageSrc: "assets/images/test_image/test_2.png",
                      ),
                      SizedBox(width: 12.w),
                      const NearClubCard(
                        clubName: "클럽 레이저",
                        clubType: "힙합",
                        clubCity: "홍대",
                        clubImageSrc: "assets/images/test_image/test_3.png",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
