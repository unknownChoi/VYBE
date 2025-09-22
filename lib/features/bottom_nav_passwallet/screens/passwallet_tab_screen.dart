import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/main_bottom_nav/widgets/main_tab_config.dart';

class PasswalletTabScreen extends StatelessWidget {
  const PasswalletTabScreen({super.key});

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
                items: const ["입장권", "예약", "이용 안내"],
                onChanged: (i) {
                  // TODO: 탭 전환
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Divider(height: 1.h, thickness: 1.h, color: const Color(0xFF2F2F33)),
        SizedBox(height: 24.h),

        PasswalletTicket(isWaitting: false),
        Spacer(),
        SizedBox(
          width: 345.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottomButton(buttonText: "순서 미루기"),
              Spacer(),
              BottomButton(buttonText: "웨이팅 취소하기"),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}

//====================버튼====================
class BottomButton extends StatelessWidget {
  const BottomButton({super.key, this.buttonText});

  final String? buttonText;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 165.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.appPurpleColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            buttonText!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
//====================버튼====================

//====================티켓 도형====================
class PasswalletTicket extends StatefulWidget {
  PasswalletTicket({super.key, this.isWaitting});

  bool? isWaitting = false;

  @override
  State<PasswalletTicket> createState() => _PasswalletTicketState();
}

class _PasswalletTicketState extends State<PasswalletTicket> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          // 상단 컨테이너
          Container(
            width: 345.w,
            height: 98.h,
            decoration: BoxDecoration(
              color: AppColors.appPurpleColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "어썸레드",
                  style: TextStyle(
                    color: Colors.white /* White */,
                    fontSize: 24.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.08.h,
                    letterSpacing: -0.60.w,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '07월 04일 금요일',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14.h,
                        letterSpacing: -0.70.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/common/dot.svg',
                      color: Color(0xFFECECEC),
                      width: 2.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '오후 8:12',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14.h,
                        letterSpacing: -0.70.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/common/dot.svg',
                      color: Color(0xFFECECEC),
                      width: 2.sp,
                    ),
                    SizedBox(width: 8.w),

                    Text(
                      widget.isWaitting! ? '입장 대기 중' : '입장완료',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 14.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.14.h,
                        letterSpacing: -0.70.w,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 본문 컨테이너
          Container(
            width: 345.w,
            height: 200.h,
            decoration: const BoxDecoration(color: Color(0Xff2f2f33)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 현재 대기 번호
                Container(
                  child: Column(
                    children: [
                      Text(
                        '현재 대기 번호',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.12,
                          letterSpacing: -0.80,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '5번',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFB5FF60) /* Main-Lime500 */,
                          fontSize: 44,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.18,
                          letterSpacing: -1.10,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            '남은 시간',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC) /* Gray200 */,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: -0.70,
                            ),
                          ),
                          Text(
                            '99:99',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC) /* Gray200 */,
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: -0.50,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.w),
                      Container(
                        width: (1.5).w,
                        height: 40.h,
                        decoration: BoxDecoration(color: Color(0xFF707071)),
                      ),
                      SizedBox(width: 25.w),
                      Column(
                        children: [
                          Text(
                            '남은 거리',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC) /* Gray200 */,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: -0.70,
                            ),
                          ),
                          Text(
                            '999m',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC) /* Gray200 */,
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: -0.50,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 25.w),
                      Container(
                        width: (1.5).w,
                        height: 40.h,
                        decoration: BoxDecoration(color: Color(0xFF707071)),
                      ),
                      SizedBox(width: 25.w),
                      Column(
                        children: [
                          Text(
                            '인원',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC) /* Gray200 */,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.14,
                              letterSpacing: -0.70,
                            ),
                          ),
                          Text(
                            '99명',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFECECEC) /* Gray200 */,
                              fontSize: 20,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.10,
                              letterSpacing: -0.50,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          // 티켓 형태(하단 천공이 겹치도록)
          Stack(
            clipBehavior: Clip.none, // 겹치기 허용
            children: [
              // 배경
              Container(
                width: 345.w,
                height: 227.h,
                decoration: const BoxDecoration(color: Color(0xFF2F2F33)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(color: Colors.white),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: 120.w,
                        height: 120.w,
                        child: Image.asset(
                          width: 120.w,
                          height: 120.w,
                          fit: BoxFit.contain,
                          'assets/images/bottom_nav_passwallet/test_qr.png',
                        ),
                      ),
                    ),

                    Positioned(
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: 345.w,
                        height: 227.h,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFF2F2F33).withOpacity(0.6),
                              ),
                              child: Text(
                                "입장시\nQR이 활성화 됩니다.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.10,
                                  letterSpacing: -0.50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 하단 천공(별도 클래스 없이 이 클래스 안에서 직접 배치)
              Positioned(
                left: 0,
                right: 0,
                // 컨테이너 하단에 반쯤 걸치도록 음수 오프셋
                bottom: -12.w,
                height: 14.h, // 스트립 높이
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double stripH = 14.h;
                    final double cy = stripH / 2;
                    final double usableW = (constraints.maxWidth - 12.w * 2)
                        .clamp(0.0, double.infinity);
                    final double step = (12 <= 1) ? 0 : usableW / (12 - 1);

                    // 점들을 개수 기반으로 균등 배치
                    return Stack(
                      clipBehavior: Clip.none,
                      children: List.generate(12, (i) {
                        final double x = 12.w + step * i;
                        return Positioned(
                          left: x - 12,
                          top: cy - 12,
                          width: 12 * 2,
                          height: 12 * 2,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.appBackgroundColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//====================티켓 도형====================

//====================상단 네비게이터바====================
class PillSegmentedNav extends StatefulWidget {
  const PillSegmentedNav({
    super.key,
    required this.items,
    this.initialIndex = 0,
    required this.onChanged,
    this.height = 36,
    this.trackColor = const Color(0xFF2E2F33), // 바탕(트랙)
    this.indicatorColor = const Color(0xFF525357), // 선택 인디케이터
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    this.unselectedOpacity = .65,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
  });

  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final Color trackColor;
  final Color indicatorColor;
  final TextStyle textStyle;
  final double unselectedOpacity;
  final BorderRadius borderRadius;

  @override
  State<PillSegmentedNav> createState() => _PillSegmentedNavState();
}

class _PillSegmentedNavState extends State<PillSegmentedNav> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final totalW = c.maxWidth;
        final innerW = totalW;
        final itemW = innerW / widget.items.length;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.trackColor,
            borderRadius: widget.borderRadius,
          ),
          child: Stack(
            children: [
              // 선택 인디케이터
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                left: itemW * _index,
                top: 0,
                bottom: 0,
                width: itemW,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.indicatorColor,
                    borderRadius: widget.borderRadius,
                  ),
                ),
              ),

              // 탭들
              Row(
                children: List.generate(widget.items.length, (i) {
                  final selected = i == _index;
                  return Expanded(
                    child: InkWell(
                      borderRadius: widget.borderRadius,
                      onTap: () {
                        if (_index == i) return;
                        setState(() => _index = i);
                        widget.onChanged(i);
                      },
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: widget.textStyle.copyWith(
                            color: Colors.white.withOpacity(
                              selected ? 1.0 : widget.unselectedOpacity,
                            ),
                          ),
                          child: Text(
                            widget.items[i],
                            style: TextStyle(
                              color: Colors.white /* White */,
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.14.h,
                              letterSpacing: -0.35.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
//====================상단 네비게이터바====================