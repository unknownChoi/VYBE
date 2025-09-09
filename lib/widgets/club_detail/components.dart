import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/constants/AppColors.dart';
import 'package:vybe/constants/app_textstyles.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/utils/subway_utils.dart';
import 'package:vybe/widgets/club_detail/common.dart';
import 'package:vybe/widgets/common/common.dart';

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
                        "${subwayInfo!['station']} 1번 출구에서 ${subwayInfo['distance']}",
                        style: TextStyle(
                          color: const Color(0xFFD1C9C9),
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.12.h,
                          letterSpacing: -0.80.w,
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
                            height: 1.12.h,
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
                            height: 1.12.h,
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
                                          height: 1.14.h,
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
            SvgPicture.asset('assets/icons/club_detail_main/entry_fee.svg'),
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
            SvgPicture.asset('assets/icons/club_detail_main/contect.svg'),
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
  const ClubSignatureSection({super.key});

  @override
  State<ClubSignatureSection> createState() => _ClubSignatureSectionState();
}

class _ClubSignatureSectionState extends State<ClubSignatureSection> {
  @override
  Widget build(BuildContext context) {
    final mainMenuItems =
        menuItemsData.values
            .expand((menuList) => menuList)
            .where((item) => item['isMain'] as bool)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("메뉴", style: AppTextStyles.sectionTitle),
            Spacer(),
            Text("전체보기", style: AppTextStyles.seeAll),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/icons/club_detail_main/arrow_right.svg'),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(thickness: 1.h, color: const Color(0xFF404042)),
        ...mainMenuItems.expand((item) {
          return [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: MenuCard(
                menuName: item['name'] as String,
                menuPrice: item['price'] as int,
                menuImageSrc: item['image'] as String,
                isRepresentative: item['isMain'] as bool,
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
  const ClubImageArea({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("사진", style: AppTextStyles.sectionTitle),
            SizedBox(width: 8.w),
            Spacer(),
            Text('전체보기', style: AppTextStyles.seeAll),
            SizedBox(width: 4.w),
            SvgPicture.asset('assets/icons/club_detail_main/arrow_right.svg'),
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
  // final List<List<String>> nearClubData;
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
            SvgPicture.asset('assets/icons/club_detail_main/arrow_right.svg'),
          ],
        ),
        SizedBox(height: 24.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/near_club/test_1.png",
              ),
              SizedBox(width: 12.w),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/near_club/test_2.png",
              ),
              SizedBox(width: 12.w),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/near_club/test_3.png",
              ),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/near_club/test_1.png",
              ),
              SizedBox(width: 12.w),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/near_club/test_2.png",
              ),
              SizedBox(width: 12.w),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/near_club/test_3.png",
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
              SvgPicture.asset('assets/icons/club_detail_main/star.svg'),
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
                                  ? 'assets/icons/club_detail_main/arrow_up.svg'
                                  : 'assets/icons/club_detail_main/arrow_down.svg',
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
            icon: 'assets/icons/club_detail_main/location_pin.svg',
            widget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
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
                      '${subwayInfo['station']}에서 ${subwayInfo['distance']}',
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
                  'assets/icons/club_detail_main/phone.svg',
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
