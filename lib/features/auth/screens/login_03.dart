// TODO: 휴대폰 인증번호 입력 페이지

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/main_shell/screens/main_shell.dart';

class Login03 extends StatefulWidget {
  final String phoneNumber;

  const Login03({super.key, required this.phoneNumber});

  @override
  State<Login03> createState() => _Login03State();
}

class _Login03State extends State<Login03> {
  static const int codeLength = 6;
  static const int timerStart = 10;

  int _remainingSeconds = timerStart;
  Timer? _timer;
  bool isTimerOver = false;
  String infoTitle = "";

  final List<TextEditingController> _codeControllers = List.generate(
    codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    codeLength,
    (_) => FocusNode(),
  );

  bool get isAllFilled =>
      _codeControllers.every((c) => c.text.trim().isNotEmpty);

  @override
  void initState() {
    super.initState();
    infoTitle = "${widget.phoneNumber}로 인증번호를 전송했습니다";
    _startTimer();
    for (final controller in _codeControllers) {
      controller.addListener(_onCodeChanged);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _codeControllers) {
      controller.removeListener(_onCodeChanged);
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = timerStart;
      isTimerOver = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerOver = true;
        });
      }
    });
  }

  void _onResend() {
    setState(() {
      infoTitle = "새로운 인증번호가 요청되었습니다";
    });
    _startTimer();
    for (final controller in _codeControllers) {
      controller.clear();
    }
    FocusScope.of(context).requestFocus(_focusNodes[0]);
  }

  void _onCodeChanged() {
    setState(() {}); // 버튼 활성화 상태 갱신
  }

  String _formatTime(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(1, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  Widget _buildCodeInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(codeLength, (i) {
        return Container(
          width: 43.w,
          height: 46.h,
          decoration: ShapeDecoration(
            color: const Color(0xFF404042),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: isTimerOver ? Colors.red : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: TextField(
            controller: _codeControllers[i],
            focusNode: _focusNodes[i],
            showCursor: false,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 1,

            style: TextStyle(
              color: const Color(0xFFECECEC),
              fontSize: 24.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              height: 1.08,
              letterSpacing: -0.60.sp,
            ),
            decoration: InputDecoration(
              border: isTimerOver ? OutlineInputBorder() : InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              counterText: "",
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (i < codeLength - 1) {
                  FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                }
              } else {
                if (i > 0) {
                  FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
                }
              }
            },
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool buttonEnabled = isAllFilled;
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.w),
          ),
        ),
        title: Text(
          "본인 인증",
          style: TextStyle(
            color: const Color(0xFFEBEDF0),
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 38.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "인증번호",
                        style: TextStyle(
                          color: AppColors.appGreenColor,
                          fontSize: 24.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1,
                          letterSpacing: -0.60.sp,
                        ),
                      ),
                      TextSpan(
                        text: "를 입력해주세요.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1,
                          letterSpacing: -0.60.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      isTimerOver
                          ? "assets/icons/auth/login_03/error.svg"
                          : 'assets/icons/auth/login_03/check_icon_grey.svg',
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      isTimerOver ? "시간이 초과되었습니다." : infoTitle,
                      style: TextStyle(
                        color:
                            isTimerOver ? Colors.red : const Color(0xFF9F9FA1),
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.17,
                        letterSpacing: -0.30.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
                Center(child: _buildCodeInputFields()),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "남은시간",
                  style: TextStyle(
                    color: const Color(0xFFCACACB),
                    fontSize: 12.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.17,
                    letterSpacing: -0.30.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatTime(_remainingSeconds),
                  style: TextStyle(
                    color: isTimerOver ? Colors.red : AppColors.appPurpleColor,
                    fontSize: 16.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _onResend,
                        child: Text(
                          "다시 요청하기",
                          style: TextStyle(
                            color: const Color(0xFFCACACB),
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.30.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(height: 0.8.h, color: const Color(0xFFCACACB)),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap:
                  buttonEnabled
                      ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MainShell()),
                        );
                      }
                      : null,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 56.h,
                decoration: ShapeDecoration(
                  color:
                      buttonEnabled
                          ? AppColors.appPurpleColor
                          : Color(0xFF2F1A5A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    "확인",
                    style: TextStyle(
                      color:
                          buttonEnabled
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.80),
                      fontSize: 18.sp,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.45.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
