import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 프로젝트 경로에 맞게 조정하세요.
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class NearTabScreen extends StatefulWidget {
  const NearTabScreen({super.key});

  @override
  State<NearTabScreen> createState() => _NearTabScreenState();
}

class _NearTabScreenState extends State<NearTabScreen> {
  // =============================
  // 공용 위젯/헬퍼
  // =============================
  BoxDecoration get _chipBox => BoxDecoration(
    color: AppColors.chipBg,
    borderRadius: BorderRadius.circular(999.r),
    border: Border.all(width: 1, color: AppColors.chipBorder),
  );

  Widget _svgIcon(
    String asset, {
    double? w,
    double? h,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      asset,
      width: w,
      height: h,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  Widget _chipText(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: _chipBox,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.chip,
      ),
    );
  }

  Widget _chipWithIcon(String label, String asset, double iconSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: _chipBox,
      child: Row(
        children: [
          Text(label, textAlign: TextAlign.center, style: AppTextStyles.chip),
          SizedBox(width: 4.w),
          _svgIcon(asset, w: iconSize, color: const Color(0xFFECECEC)),
        ],
      ),
    );
  }

  // 칩 데이터
  final List<Map<String, dynamic>> _chips = const [
    {
      'label': '추천순',
      'icon': 'assets/icons/club_detail/arrow_down.svg',
      'sizeSp': 8.0,
    },
    {
      'label': '필터',
      'icon': 'assets/icons/bottom_nav_near/filter.svg',
      'sizeSp': 12.0,
    },
    {'label': '영업중'},
    {'label': '입장비 무료'},
    {'label': '서비스 음료'},
    {'label': '금연 클럽'},
    {'label': '추천순'},
  ];

  // =============================
  // Naver Map
  // =============================
  NaverMapController? _mapController;
  NMarker? _marker;
  late final NCameraPosition _initialCameraPosition;

  void _loadMarker(NLatLng position) {
    final icon = NOverlayImage.fromAssetImage(
      'assets/images/common/map_location_pin.png',
    );

    _marker = NMarker(
      id: 'my-marker',
      position: position,
      icon: icon,
      size: NSize(20.w, 22.w),
    );

    if (_mapController != null && _marker != null) {
      _mapController!.addOverlay(_marker!);
    }
  }

  @override
  void initState() {
    super.initState();
    _initialCameraPosition = const NCameraPosition(
      target: NLatLng(37.550947012, 126.921849684),
      zoom: 16,
      bearing: 0,
      tilt: 0,
    );

    // 컨트롤러 준비 전: 마커 구성(컨트롤러 준비되면 addOverlay)
    _loadMarker(const NLatLng(37.550947012, 126.921849684));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // === 지도 ===
          SizedBox.expand(
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

          // === 상단 UI ===
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          width: 36.w,
                          height: 36.w,
                          padding: EdgeInsets.symmetric(
                            vertical: 5.h,
                            horizontal: 11.w,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.topBar,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20.sp,
                              color: AppColors.gray400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Container(
                          height: 42.h,
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 16.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.topBar,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              _svgIcon(
                                'assets/icons/common/search.svg',
                                w: 22.sp,
                                color: AppColors.gray400,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // 칩 리스트
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 8.h,
                  ),
                  child: SizedBox(
                    height: 36.h,
                    child: ScrollConfiguration(
                      behavior: NoGlowBehavior(),
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(), // iOS 바운스 제거
                        itemCount: _chips.length,
                        separatorBuilder: (_, __) => SizedBox(width: 8.w),
                        itemBuilder: (context, i) {
                          final c = _chips[i];
                          final label = c['label'] as String;
                          final icon = c['icon'] as String?;
                          final sizeSp = c['sizeSp'] as double?;
                          return (icon != null)
                              ? _chipWithIcon(label, icon, (sizeSp ?? 10).sp)
                              : _chipText(label);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // === 드래그 시트 ===
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.sheet,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                  children: [
                    // 상단 핸들(옵션)
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _clubCard(
                      name: "어썸레드",
                      rating: 4.76,
                      location: "홍대 | 힙합 클럽",
                      description: "서울 강남구 도산대로 81길 42 지하 1층",
                      isVybeClub: true,
                    ),
                    const Divider(color: Color(0xFF404042)),
                    _clubCard(
                      name: "홍대 클럽 레이저",
                      rating: 4.76,
                      location: "홍대 | 힙합 클럽",
                      description: "서울 마포구 홍익로 12",
                      isVybeClub: false,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =============================
  // 카드
  // =============================
  Widget _clubCard({
    required String name,
    required double rating,
    required String location,
    required String description,
    required bool isVybeClub,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 + 추천 뱃지
          Row(
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.clubName,
              ),
              SizedBox(width: 8.w),
              if (isVybeClub)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _svgIcon(
                      'assets/icons/bottom_nav_near/vybe_club_mark.svg',
                      w: 10.w,
                      h: 9.h,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "VYBE 추천 클럽",
                      style: AppTextStyles.meta.copyWith(
                        color: AppColors.lime500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 4.h),

          // 평점/카테고리
          Row(
            children: [
              _svgIcon('assets/icons/common/star.svg', w: 12.w, h: 12.w),
              SizedBox(width: 4.w),
              Text("$rating", style: AppTextStyles.rating),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.location,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // 대표 이미지
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              'assets/images/test_image/test_image.png', // 경로 먼저
              width: 345.w,
              height: 152.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8.h),

          // 주소
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _svgIcon(
                'assets/icons/common/location_pin.svg',
                w: 14.w,
                h: 14.w,
                color: AppColors.chipBorder,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.meta,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // 영업/입장비
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 2.w),
              _svgIcon(
                'assets/icons/common/time.svg',
                w: 12.w,
                h: 12.w,
                color: AppColors.chipBorder,
              ),
              SizedBox(width: 8.w),
              Text("영업중", style: AppTextStyles.meta),
              SizedBox(width: 4.w),
              _svgIcon('assets/icons/common/dot.svg', w: 4.w, h: 4.w),
              SizedBox(width: 4.w),
              Text("02:00에 영업 종료", style: AppTextStyles.meta),
              SizedBox(width: 16.w),
              _svgIcon(
                'assets/icons/common/entry_fee.svg',
                w: 15.w,
                h: 15.w,
                color: AppColors.chipBorder,
              ),
              SizedBox(width: 8.w),
              Text("10,000원", style: AppTextStyles.meta),
            ],
          ),
        ],
      ),
    );
  }
}

// 스크롤 글로우/바운스 제거(로컬 사용)
class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
