import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
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
              // 0) 입장권: 가로 캐러셀
              PasswalletCarousel(
                items: passwalletTicketData, // mock 데이터
                initialIndex: 0,
                onSelectedIndexChanged: (i) {
                  // 필요 시 현재 카드 인덱스 상태 갱신 로직
                },
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
