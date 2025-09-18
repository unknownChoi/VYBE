import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import '../utils/subway_utils.dart';

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
        // 주소 + 지하철
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
                  if (subwayInfo != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                          "${subwayInfo['station']} ${subwayInfo['exitNum']}번 출구에서 ${subwayInfo['distance']}",
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

        // 영업시간
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
                    onTap:
                        () => setState(
                          () =>
                              _isBusinessHoursExpanded =
                                  !_isBusinessHoursExpanded,
                        ),
                    child: Row(
                      children: [
                        Text(
                          "영업중",
                          style: TextStyle(
                            color: const Color(0xFFECECEC),
                            fontSize: 16.sp,
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
                            businessHours
                                .map(
                                  (entry) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.h,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          entry['day']!,
                                          style: const TextStyle(
                                            color: Color(0xFFCACACB),
                                          ),
                                        ),
                                        SizedBox(width: 4.w),
                                        SvgPicture.asset(
                                          'assets/icons/club_detail/dot.svg',
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          entry['hours']!,
                                          style: const TextStyle(
                                            color: Color(0xFFCACACB),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // 입장료
        Row(
          children: [
            SvgPicture.asset('assets/icons/club_detail/entry_fee.svg'),
            SizedBox(width: 12.w),
            Text(
              clubData['entryFee'],
              style: TextStyle(color: const Color(0xFFECECEC), fontSize: 16.sp),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // 인스타
        Row(
          children: [
            SvgPicture.asset('assets/icons/club_detail/contect.svg'),
            SizedBox(width: 12.w),
            Text(
              clubData['instagramUrl'],
              style: const TextStyle(color: Color(0xFF2B6AFF), fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}
