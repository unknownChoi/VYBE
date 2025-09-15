// TODO: 로그인/회원가입 선택 화면

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/features/auth/screens/login_02.dart';
import 'package:vybe/core/app_colors.dart';

class Login01 extends StatelessWidget {
  const Login01({super.key});

  @override
  Widget build(BuildContext context) {
    // 중첩 MaterialApp 제거: 상위(MaterialApp/ScreenUtilInit) 컨텍스트를 사용
    return const VybeLoginScreen();
  }
}

class VybeLoginScreen extends StatelessWidget {
  const VybeLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 202.h),
            _LogoAndTitle(),
            const Spacer(),
            _LoginButtons(),
          ],
        ),
      ),
    );
  }
}

class _LogoAndTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/common/main_logo.png',
            width: 180.w,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 36.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '바이브',
                  style: _mainTitleStyle.copyWith(
                    color: const Color(0xFFB5FF60),
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' 탈 준비 됐어?',
                  style: _mainTitleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '우린 ',
                  style: _subTitleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 44.sp,
                  ),
                ),
                TextSpan(
                  text: '끝냈어!',
                  style: _subTitleStyle.copyWith(
                    color: const Color(0xFF7731FE),
                    fontSize: 44.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialLoginButton(
          color: const Color(0xFFFEE500),
          text: '카카오 로그인',
          textColor: const Color(0xFF191919),
          iconPath: 'assets/icons/auth/login_01/kakao_icon.svg',
        ),
        SizedBox(height: 16.h),
        SocialLoginButton(
          color: const Color(0xFF02C75A),
          text: '네이버 로그인',
          textColor: Colors.white,
          iconPath: 'assets/icons/auth/login_01/naver_icon.svg',
        ),
        SizedBox(height: 16.h),
        SocialLoginButton(
          color: Colors.white,
          text: 'Apple 로그인',
          textColor: Colors.black,
          iconPath: 'assets/icons/auth/login_01/apple_icon.svg',
        ),
        SizedBox(height: 24.h),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              backgroundColor: const Color(0xFF2F2F33),
              context: context,
              builder: (context) {
                return SizedBox(
                  width: 1.sw,
                  height: 422.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 29.w,
                      vertical: 64.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/auth/login_01/check_icon_green.svg',
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          '본인 인증이 필요합니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          '19세 이상 사용 가능 서비스 입니다.\n본인 인증을 진행해주세요.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF8E8E8E),
                            fontSize: 16.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 42.h),
                        SizedBox(
                          width: 1.sw,
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login02(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 24.sp,
                                ),
                                Expanded(
                                  child: Text(
                                    "본인인증 로그인",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Pretendard',
                                      letterSpacing: 0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text('다른 방법으로 로그인', style: _footerStyle),
        ),
        SizedBox(height: 81.h),
      ],
    );
  }
}

// 스타일 상수
const TextStyle _mainTitleStyle = TextStyle(
  fontWeight: FontWeight.w400,
  fontFamily: 'Pretendard',
);

const TextStyle _subTitleStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontFamily: 'Pretendard',
);

final TextStyle _footerStyle = TextStyle(
  color: Color(0xFFB5B5B5),
  fontSize: 14.sp,
  fontWeight: FontWeight.w500,
);

// 소셜 로그인 버튼 위젯 (클래스명 변경 금지)
class SocialLoginButton extends StatelessWidget {
  final Color color;
  final String text;
  final Color textColor;
  final String iconPath;

  const SocialLoginButton({
    super.key,
    required this.color,
    required this.text,
    required this.textColor,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: 48.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 아이콘
            SizedBox(
              width: 24.w,
              height: 22.h,
              child: SvgPicture.asset(iconPath),
            ),
            // 텍스트
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Pretendard',
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
