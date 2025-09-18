import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import '../utils/subway_utils.dart';

import 'info_row.dart';

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
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
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
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w700,
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
