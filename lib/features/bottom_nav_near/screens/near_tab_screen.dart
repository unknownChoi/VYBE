import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NearTabScreen extends StatefulWidget {
  const NearTabScreen({super.key});

  @override
  State<NearTabScreen> createState() => _NearTabScreenState();
}

class _NearTabScreenState extends State<NearTabScreen> {
  NaverMapController? _mapController;
  NMarker? _marker;
  late final NCameraPosition _initialCameraPosition;

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
  void initState() {
    super.initState();

    _initialCameraPosition = NCameraPosition(
      target: NLatLng(37.550947012, 126.921849684),
      zoom: 16,
      bearing: 0,
      tilt: 0,
    );

    _loadMarker(NLatLng(37.550947012, 126.921849684));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 지도(임시)
          Container(
            color: Colors.red,
            width: double.infinity,
            height: double.infinity,
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
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        padding: EdgeInsets.symmetric(
                          vertical: 5.h,
                          horizontal: 11.w,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF404042),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 20.sp,
                            color: Color(0XFFCACACB),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 297.w,
                      height: 42.h,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF404042),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          SvgPicture.asset(
                            'assets/icons/bottom_nav/search.svg',
                            color: const Color(0XFFCACACB),
                            width: 22.sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _chipWithIcon(
                          '추천순',
                          'assets/icons/club_detail/arrow_down.svg',
                          8.sp,
                        ),
                        SizedBox(width: 8.w),
                        _chipWithIcon(
                          '필터',
                          'assets/icons/bottom_nav_near/filter.svg',
                          12.sp,
                        ),
                        SizedBox(width: 8.w),
                        _chipText('영업중'),
                        SizedBox(width: 8.w),
                        _chipText('입장비 무료'),
                        SizedBox(width: 8.w),
                        _chipText('서비스 음료'),
                        SizedBox(width: 8.w),
                        _chipText('금연 클럽'),
                        SizedBox(width: 8.w),
                        _chipText('추천순'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 드래그 시트
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                height: 600.h,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 44, 44, 49),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  controller: scrollController,
                  children: [
                    SizedBox(height: 20.h),
                    _clubCard(
                      name: "어썸레드",
                      rating: 4.76,
                      location: "홍대 | 힙합 클럽",
                      description: "서울 강남구 도산대로 81길 42 지하 1층",
                      isVybeClub: true,
                    ),
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

  Widget _chipText(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(width: 1, color: const Color(0xFF535355)),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFECECEC),
          fontSize: 12.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          letterSpacing: -0.24.sp,
        ),
      ),
    );
  }

  Widget _chipWithIcon(String label, String asset, double iconSize) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(width: 1, color: const Color(0xFF535355)),
      ),
      child: Row(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFFECECEC),
              fontSize: 12.sp,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.24.sp,
            ),
          ),
          SizedBox(width: 4.w),
          SvgPicture.asset(
            asset,
            width: iconSize,
            color: const Color(0xFFECECEC),
          ),
        ],
      ),
    );
  }

  Widget _clubCard({
    required String name,
    required double rating,
    required String location,
    required String description,
    required bool isVybeClub,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      // decoration: BoxDecoration(
      //   color: const Color(0xFF2A2A2D),
      //   borderRadius: BorderRadius.circular(12.r),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white /* White */,
                  fontSize: 20,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.10,
                  letterSpacing: -0.50,
                ),
              ),
              SizedBox(width: 8.w),
              if (isVybeClub)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/bottom_nav_near/vybe_club_mark.svg',
                      width: 10.w,
                      height: 9.h,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "VYBE 추천 클럽",
                      style: TextStyle(
                        color: const Color(0xFFB5FF60) /* Main-Lime500 */,
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.17,
                        letterSpacing: -0.60,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              SvgPicture.asset('assets/icons/common/star.svg'),
              SizedBox(width: 4.w),
              Text(
                "$rating",
                style: TextStyle(
                  color: Colors.white /* White */,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.17,
                  letterSpacing: -0.60,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                location,
                style: TextStyle(
                  color: const Color(0xFF9F9FA1) /* Gray500 */,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.17,
                  letterSpacing: -0.30,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              width: 345.w,
              height: 152.h,
              fit: BoxFit.cover,
              'assets/images/test_image/test_image.png',
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/common/location_pin.svg',
                width: 14.w,
                color: Color(0XFF535355),
              ),
              SizedBox(width: 8.w),
              Text(
                description,
                style: TextStyle(
                  color: const Color(0xFFCACACB) /* Gray400 */,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.17,
                  letterSpacing: -0.30,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 2.w),
              SvgPicture.asset(
                'assets/icons/common/time.svg',
                width: 12.w,
                color: Color(0XFF535355),
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  Text(
                    "영업중",
                    style: TextStyle(
                      color: const Color(0xFFCACACB) /* Gray400 */,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.17,
                      letterSpacing: -0.30,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  SvgPicture.asset('assets/icons/common/dot.svg'),
                  SizedBox(width: 4.w),
                  Text(
                    "02:00에 영업 종료",
                    style: TextStyle(
                      color: const Color(0xFFCACACB) /* Gray400 */,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.17,
                      letterSpacing: -0.30,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.w),
              SvgPicture.asset(
                'assets/icons/common/entry_fee.svg',
                width: 15.w,
                color: Color(0XFF535355),
              ),
              SizedBox(width: 8.w),
              Text(
                "10,000원",
                style: TextStyle(
                  color: const Color(0xFFCACACB) /* Gray400 */,
                  fontSize: 12,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.17,
                  letterSpacing: -0.30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
