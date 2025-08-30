import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vybe/constants/AppColors.dart';
import 'package:vybe/constants/app_textstyles.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/utils/subway_utils.dart';

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
              child: SvgPicture.asset(
                'assets/icons/club_detail_main/location_pin.svg',
              ),
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
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.12,
                            letterSpacing: -0.80,
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
                            horizontal: 6.0,
                            vertical: 2.0,
                          ),
                          child: Text(
                            subwayInfo['line']! as String,
                            style: AppTextStyles.stationNumber,
                          ),
                        ),
                      SizedBox(width: 8.0),
                      Text(
                        "${subwayInfo!['station']} 1번 출구에서 ${subwayInfo['distance']}",
                        style: TextStyle(
                          color: const Color(0xFFD1C9C9),
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.12,
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
              child: SvgPicture.asset('assets/icons/club_detail_main/time.svg'),
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
                            height: 1.12,
                            letterSpacing: -0.80,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        SvgPicture.asset(
                          'assets/icons/club_detail_main/dot.svg',
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "02:00에 영업종료",
                          style: TextStyle(
                            color: const Color(0xFFECECEC),
                            fontSize: 16.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.12,
                            letterSpacing: -0.80,
                          ),
                        ),

                        SizedBox(width: 12.w),
                        SvgPicture.asset(
                          _isBusinessHoursExpanded
                              ? 'assets/icons/club_detail_main/arrow_up.svg'
                              : 'assets/icons/club_detail_main/arrow_down.svg',
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
                                          height: 1.14,
                                          letterSpacing: -0.70,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    SvgPicture.asset(
                                      'assets/icons/club_detail_main/dot.svg',
                                    ),

                                    SizedBox(width: 4.w),
                                    Text(
                                      entry['hours']!,
                                      style: TextStyle(
                                        color: const Color(0xFFCACACB),
                                        fontSize: 14.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 1.14,
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
            SvgPicture.asset('assets/icons/club_detail_main/entry_fee.svg'),
            SizedBox(width: 12.w),
            Text(
              clubData['entryFee'],
              style: TextStyle(
                color: const Color(0xFFECECEC),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.12,
                letterSpacing: -0.80,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            SvgPicture.asset('assets/icons/club_detail_main/contect.svg'),
            SizedBox(width: 12.w),
            Text(
              clubData['instagramUrl'],
              style: TextStyle(
                color: const Color(0xFF2B6AFF),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.12,
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
  const ClubSignatureSection({super.key});

  @override
  State<ClubSignatureSection> createState() => _ClubSignatureSectionState();
}

class _ClubSignatureSectionState extends State<ClubSignatureSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "메뉴",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.10,
                letterSpacing: -0.50,
              ),
            ),
            Spacer(),
            Text(
              "전체보기",
              style: TextStyle(
                color: const Color(0xFFCACACB),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.17,
                letterSpacing: -0.30,
              ),
            ),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/icons/club_detail_main/arrow_right.svg'),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(thickness: 1.h, color: const Color(0xFF404042)),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: MenuCard(),
        ),
        Divider(thickness: 1.h, color: const Color(0xFF404042)),
      ],
    );
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      // menu item card
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  width: 25.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColors.appPurpleColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Center(
                    child: Text(
                      "대표",
                      style: TextStyle(
                        color: const Color(0xFFECECEC),
                        fontSize: 10.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.40,
                        letterSpacing: -0.50,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  "LEMON DROP",
                  style: TextStyle(
                    color: const Color(0xFFECECEC),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "100,000원",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.11,
                letterSpacing: -0.90,
              ),
            ),
          ],
        ),
        Spacer(),
        Image.asset('assets/images/test_image_2.png'),
      ],
    );
  }
}
