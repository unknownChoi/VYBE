import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/dialong_widget.dart';
import 'package:vybe/core/utils/dialog_launcher.dart';
import 'package:vybe/features/bottom_nav_passwallet/screens/passwallet_tab_screen.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/ticket/passwallet_ticket.dart';
import 'package:vybe/features/club_detail_page/widgets/atoms/action_button.dart';
import 'package:vybe/features/main_bottom_nav/widgets/main_tab_config.dart';
import 'package:vybe/features/main_shell/screens/main_shell.dart';

class ClubDetailBottomBar extends StatelessWidget {
  const ClubDetailBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      height: 92.h,
      color: const Color(0xFF1B1B1D),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/club_detail/heart.svg'),
              SizedBox(height: 2.h),
              Text('000', style: AppTextStyles.bottomBarText),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              final rootContext = context;

              showModalBottomSheet(
                context: rootContext,
                isScrollControlled: true,
                builder: (sheetCtx) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFF2F2F33),
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                      top: 20.h,
                      bottom: 37.h,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Text(
                            '어썸 레드',
                            style: TextStyle(
                              color: Colors.white /* White */,
                              fontSize: 24,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.08,
                              letterSpacing: -0.60,
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 36.w,
                            vertical: 24.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                width: 1.w,
                                color: Color(0xFF404042),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "현재 웨이팅",
                                    style: TextStyle(
                                      color: Colors.white /* White */,
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.10,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Text(
                                    '2팀',
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF94CF51,
                                      ) /* Main-Lime700 */,
                                      fontSize: 32,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      height: 1.06,
                                      letterSpacing: -0.80,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    "에상 대기시간",
                                    style: TextStyle(
                                      color: Colors.white /* White */,
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.10,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  Text(
                                    '40분',
                                    style: TextStyle(
                                      color: const Color(
                                        0xFF94CF51,
                                      ) /* Main-Lime700 */,
                                      fontSize: 32,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                      height: 1.06,
                                      letterSpacing: -0.80,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 36.w,
                          ),
                          child: Row(
                            children: [
                              Text(
                                '인원',
                                style: TextStyle(
                                  color: Colors.white /* White */,
                                  fontSize: 20,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.10,
                                  letterSpacing: -0.50,
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Container(
                                    width: 24.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        999.r,
                                      ),
                                      border: Border.all(
                                        width: 1.w,
                                        color: Color(0xFF979797),
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        width: 10.sp,
                                        'assets/icons/common/minus.svg',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    '2',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      height: 1.10,
                                      letterSpacing: -0.50,
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Container(
                                    width: 24.w,
                                    height: 24.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        999.r,
                                      ),
                                      border: Border.all(
                                        width: 1.w,
                                        color: Color(0xFF979797),
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        width: 10.w,
                                        'assets/icons/common/plus.svg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Color(0xFF404042),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '매장 웨이팅 유의사항',
                                style: TextStyle(
                                  color: const Color(0xFFECECEC) /* Gray200 */,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.14,
                                  letterSpacing: -0.35,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                '웨이팅 등록 후, 방문을 하지 않으면 방문 이력이 노쇼로 처리될 수 있습니다. 노쇼로 처리될 경우, 이후 서비스 이용에 제한이 생길 수 있으니 이 점 확인 부탁드립니다.\n\n웨이팅을 등록하면 알림을 드립니다.',
                                style: TextStyle(
                                  color: const Color(0xFFECECEC) /* Gray200 */,
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.17,
                                  letterSpacing: -0.30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: WaitingModelSheetButton(
                                isBackgroundColor: false,
                                onTap: () {
                                  Navigator.pop(sheetCtx);
                                },
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: WaitingModelSheetButton(
                                isBackgroundColor: true,
                                onTap: () {
                                  Navigator.pop(context);

                                  showScaleBlurDialog<void>(
                                    context,
                                    DialongWidget(
                                      dialogWidget: DefaultTextStyle(
                                        style: const TextStyle(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "웨이팅 등록 완료!",
                                              style: AppTextStyles
                                                  .dialogTitleTextStyle,
                                            ),
                                            SizedBox(height: 12.h),
                                            Text(
                                              "요청하신 웨이팅이 접수되었어요.",
                                              style: AppTextStyles
                                                  .dialogDescriptionTextStyle,
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              "진행 상황은 알람으로 알려드려요!",
                                              style: AppTextStyles
                                                  .dialogDescriptionTextStyle,
                                            ),
                                            SizedBox(height: 24.h),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      ClubDetailDialongButton(
                                                        buttonText: "확인",
                                                        onTap: () {
                                                          Navigator.of(
                                                            context,
                                                          ).pop();
                                                        },
                                                      ),
                                                ),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: ClubDetailDialongButton(
                                                    buttonText: "웨이팅 내역 보기",
                                                    onTap: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop(); // 다이얼로그 닫기
                                                      Navigator.of(
                                                        context,
                                                        rootNavigator: true,
                                                      ).pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              const MainShell(
                                                                initialIndex: 2,
                                                              ),
                                                        ),
                                                        (route) => false,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const ActionButton(text: '웨이팅 등록', outlined: true),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: const ActionButton(text: '테이블 예약'),
          ),
        ],
      ),
    );
  }
}

class ClubDetailDialongButton extends StatelessWidget {
  const ClubDetailDialongButton({
    super.key,
    required this.buttonText,
    this.onTap,
  });

  final String buttonText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.appPurpleColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(buttonText, style: AppTextStyles.dialogButtonTextStyle),
        ),
      ),
    );
  }
}

class WaitingModelSheetButton extends StatelessWidget {
  const WaitingModelSheetButton({
    super.key,
    required this.isBackgroundColor,
    this.onTap,
  });

  final bool isBackgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: isBackgroundColor ? AppColors.appPurpleColor : null,
          border: isBackgroundColor
              ? null
              : Border.all(width: 1.w, color: Color(0xFF535355)),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Center(
          child: Text(
            isBackgroundColor ? '웨이팅 등록하기' : '취소',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFECECEC) /* Gray200 */,
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
