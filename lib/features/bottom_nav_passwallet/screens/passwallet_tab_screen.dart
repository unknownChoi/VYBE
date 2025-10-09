import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/widgets/custom_divider.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/club_detail_page/widgets/sections/near_club_section.dart';
import '../widgets/passwallet_carousel.dart';
import '../widgets/history_section.dart';
import '../widgets/pill_segmented_nav.dart';
import '../widgets/reservation_section.dart';

class PasswalletTabScreen extends StatefulWidget {
  const PasswalletTabScreen({super.key});

  @override
  State<PasswalletTabScreen> createState() => _PasswalletTabScreenState();
}

class _PasswalletTabScreenState extends State<PasswalletTabScreen> {
  int _selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 22.h),
        SafeArea(
          child: Center(
            child: SizedBox(
              width: 345.w,
              height: 36.h,
              child: PillSegmentedNav(
                items: const ["입장권", "예약", "이용 내역"],
                onChanged: (i) {
                  setState(() {
                    _selectIndex = i;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Divider(height: 1.h, thickness: 1.h, color: const Color(0xFF2F2F33)),
        // 기존 Expanded(...) 교체
        Expanded(
          child: IndexedStack(
            index: _selectIndex,
            children: [
              passwalletTicketData.isEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 50.h),
                          Center(
                            child: SizedBox(
                              width: 120.w, // 원하는 크기
                              height: 120.w, // 정사각 권장
                              child: Stack(
                                alignment: Alignment.center,
                                clipBehavior: Clip.none,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/bottom_nav_passwallet/ticket_is_not_exits.svg',
                                    width: 126.w,
                                    height: 126.w,
                                  ),
                                  Positioned(
                                    bottom: -8,
                                    right: -35,
                                    child: SvgPicture.asset(
                                      'assets/icons/bottom_nav_passwallet/ticket_is_not_exits_xmark.svg',
                                      width: 63.w,
                                      height: 63.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 44.h),
                          Text(
                            '현재 웨이팅 중인 매장이 없어요.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.08,
                              letterSpacing: -0.60,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            '웨이팅 가능한 매장을 찾아보세요!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFCACACB),
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.12,
                              letterSpacing: -0.80,
                            ),
                          ),
                          SizedBox(height: 50.h),
                          const CustomDivider(),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              vertical: 40.h,
                              horizontal: 24.w,
                            ),
                            child: NearClubSection(),
                          ),
                        ],
                      ),
                    )
                  : PasswalletCarousel(
                      items: passwalletTicketData, // mock 데이터
                      initialIndex: 0,
                      onSelectedIndexChanged: (i) {},
                    ),

              // 1) 예약
              const ReservationSection(),

              // 2) 이용 내역
              const HistorySection(),
            ],
          ),
        ),
      ],
    );
  }
}
