// TODO: 상세정보 ㅇ

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/loading_animation.dart';
import 'package:vybe/features/auth/screens/consent_detail_page.dart';
import 'package:vybe/features/auth/screens/login_03.dart';
import 'package:vybe/features/auth/utils/login_02_constants.dart';
import 'package:vybe/features/auth/utils/login_02_validators.dart';
import 'package:vybe/features/auth/widgets/login_02_birthinput.dart';
import 'package:vybe/features/auth/widgets/login_02_carrierfield.dart';
import 'package:vybe/features/auth/widgets/login_02_inputfield.dart';
import 'package:vybe/features/main_shell/screens/main_shell.dart';
import 'package:vybe/services/firebase/firebase_service.dart';

class Login02 extends StatefulWidget {
  const Login02({super.key});

  @override
  State<Login02> createState() => _Ui02MainState();
}

class _Ui02MainState extends State<Login02> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rrnFrontController = TextEditingController();
  final TextEditingController _rrnBackController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _carrierController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _rrnFrontFocus = FocusNode();
  final FocusNode _rrnBackFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  int _step = 0;
  int _prevRrnFrontLength = 0;

  bool get _isButtonEnabled {
    switch (_step) {
      case 0:
        return _nameController.text.trim().isNotEmpty;
      case 1:
        final front = _rrnFrontController.text;
        final back = _rrnBackController.text;
        final isAdult =
            front.length == 6 &&
            back.length == 1 &&
            !isInvalidBirthYearUi02(front, back[0]);
        return isAdult;
      case 2:
        return _phoneController.text.length == 13;
      case 3:
        return _carrierController.text.trim().isNotEmpty;
      default:
        return false;
    }
  }

  List<TextEditingController> get controllers => [
    _nameController,
    _rrnFrontController,
    _phoneController,
    _carrierController,
  ];

  List<TextEditingController> get rrnControllers => [
    _rrnFrontController,
    _rrnBackController,
  ];

  List<TextInputType> get keyboardTypes => [
    TextInputType.text,
    TextInputType.number,
    TextInputType.number,
    TextInputType.text,
  ];

  @override
  void initState() {
    super.initState();
    _prevRrnFrontLength = _rrnFrontController.text.length;
    for (final c in [
      _nameController,
      _rrnFrontController,
      _rrnBackController,
      _phoneController,
      _carrierController,
    ]) {
      c.addListener(_onAnyChanged);
    }

    _rrnFrontController.addListener(_handleStepInput);
    _rrnBackController.addListener(_handleStepInput);
    _phoneController.addListener(_handleStepInput);
  }

  void _onAnyChanged() => setState(() {});

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _rrnFrontController,
      _rrnBackController,
      _phoneController,
      _carrierController,
    ]) {
      c.removeListener(_onAnyChanged);
    }
    _nameController.dispose();
    _rrnFrontController.dispose();
    _rrnBackController.dispose();
    _phoneController.dispose();
    _carrierController.dispose();
    _nameFocus.dispose();
    _rrnFrontFocus.dispose();
    _rrnBackFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  void _handleStepInput() {
    switch (_step) {
      case 1:
        if (_rrnFrontController.text.length == 6 && _prevRrnFrontLength < 6) {
          FocusScope.of(context).requestFocus(_rrnBackFocus);
        }
        if (_rrnFrontController.text.length == 6 &&
            _rrnBackController.text.length == 1) {
          final isAdult =
              !isInvalidBirthYearUi02(
                _rrnFrontController.text,
                _rrnBackController.text,
              );
          if (isAdult) {
            setState(() {
              _step += 1;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context).requestFocus(_phoneFocus);
            });
          }
        }
        break;
      case 2:
        if (_phoneController.text.length == 13) {
          setState(() {
            _step += 1;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Login02CarrierField.showCarrierModal(
              context: context,
              controller: _carrierController,
              onCarrierSelected: (carrier) {},
            );
          });
        }
        break;
    }
    _prevRrnFrontLength = _rrnFrontController.text.length;
  }

  void _goToNextStep() {
    setState(() {
      if (_step < 3) _step += 1;
    });
  }

  Widget _buildPromptText() {
    if (_step == 1) {
      final String frontText = _rrnFrontController.text;
      final String backText = _rrnBackController.text;
      final bool invalidBirth =
          frontText.length == 6 && backText.isNotEmpty
              ? isInvalidBirthYearUi02(frontText, backText[0])
              : false;

      final Color messageColor = invalidBirth ? Colors.red : Color(0xFF9F9FA1);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: kPrompts.keys.elementAt(_step),
                  style: TextStyle(
                    color: AppColors.appGreenColor,
                    fontSize: 24.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.90.sp,
                  ),
                ),
                TextSpan(
                  text: " ${kPrompts.values.elementAt(_step)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.90.sp,
                  ),
                ),
              ],
            ),
            key: ValueKey(_step),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/auth/login_02/notice_icon.svg',
                color: messageColor,
                width: 16.w,
                height: 16.w,
              ),
              SizedBox(width: 6.w),
              Text(
                "이 서비스는 만 19세 이상만 이용 가능합니다.",
                style: TextStyle(
                  color: messageColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.30.sp,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: kPrompts.keys.elementAt(_step),
              style: TextStyle(
                color: const Color(0xFFB5FF60),
                fontSize: 24.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.90.sp,
              ),
            ),
            TextSpan(
              text: " ${kPrompts.values.elementAt(_step)}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.90.sp,
              ),
            ),
          ],
        ),
        key: ValueKey(_step),
      );
    }
  }

  void _onconfirmPressed() async {
    if (_step == 3) {
      Map<String, bool> checked = {
        for (var key in consentItemsUi02.keys) key: false,
      };
      bool allCheck = false;

      await showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.modelSheetColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (modalContext) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              void updateAllCheck() {
                allCheck = consentItemsUi02.entries
                    .where((entry) => entry.value == '(필수)')
                    .every((entry) => checked[entry.key] == true);
              }

              void onAllCheckTap() {
                setModalState(() {
                  allCheck = !allCheck;
                  for (var key in checked.keys) {
                    checked[key] = allCheck;
                  }
                });
              }

              void onItemCheckTap(String key) {
                setModalState(() {
                  checked[key] = !checked[key]!;
                  updateAllCheck();
                });
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 420.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      const Text(
                        "서비스 이용을 위해 동의가 필요해요.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.10,
                          letterSpacing: -0.50,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: onAllCheckTap,
                            child:
                                allCheck
                                    ? Icon(
                                      Icons.check_box,
                                      color: AppColors.appGreenColor,
                                      size: 16.w,
                                    )
                                    : Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.white,
                                      size: 16.w,
                                    ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            "전체 동의하기",
                            style: TextStyle(
                              color: Color(0xFFECECEC),
                              fontSize: 20.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      ...consentItemsUi02.entries.map((entry) {
                        final title = entry.key;
                        final tag = entry.value;
                        final isChecked = checked[title] ?? false;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => onItemCheckTap(title),
                                child:
                                    isChecked
                                        ? SvgPicture.asset(
                                          'assets/icons/auth/login_02/checked.svg',
                                        )
                                        : SvgPicture.asset(
                                          'assets/icons/auth/login_02/unchecked.svg',
                                        ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                title,
                                style: TextStyle(
                                  color: const Color(0xFFE4E4E5),
                                  fontSize: 18.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.11,
                                  letterSpacing: -0.45,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                tag,
                                style: TextStyle(
                                  color: const Color(0xFF8E8E8E),
                                  fontSize: 16.sp,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.12,
                                  letterSpacing: -0.80,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(modalContext).push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ConsentDetailPage(
                                            consentTitle: title,
                                          ),
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/auth/login_02/more_consent.svg',
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 24.h),
                      GestureDetector(
                        onTap:
                            allCheck
                                ? () async {
                                  // navigator와 messenger, context를 가장 바깥(this.context)에서 미리 캡처
                                  final navigator = Navigator.of(this.context);
                                  final messenger = ScaffoldMessenger.of(
                                    this.context,
                                  );

                                  // 동의 모달 먼저 닫기
                                  Navigator.of(modalContext).pop();

                                  if (!mounted) return;

                                  // (1) 로딩 다이얼로그를 루트 네비게이터에서 띄움
                                  showDialog(
                                    context: this.context,
                                    barrierDismissible: false,
                                    useRootNavigator: true,
                                    builder:
                                        (context) => const Center(
                                          child: LoadingAnimation(),
                                        ),
                                  );

                                  try {
                                    final exists =
                                        await FirebaseService.isUserExists(
                                          _phoneController.text.replaceAll(
                                            "-",
                                            "",
                                          ),
                                        );

                                    // (2) 화면 이동 전에 반드시 다이얼로그 닫기
                                    if (mounted) {
                                      Navigator.of(
                                        this.context,
                                        rootNavigator: true,
                                      ).pop();
                                    }

                                    // (3) 결과에 따라 화면 이동
                                    if (exists) {
                                      navigator.pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const MainShell(),
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      navigator.pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => Login03(
                                                phoneNumber:
                                                    _phoneController.text,
                                              ),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  } catch (e) {
                                    // 에러 발생 시 다이얼로그 닫고 스낵바 표시
                                    Navigator.of(
                                      this.context,
                                      rootNavigator: true,
                                    ).pop();
                                    if (mounted) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text('오류가 발생했습니다: $e'),
                                        ),
                                      );
                                    }
                                  }
                                }
                                : null,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 56.h,
                          decoration: ShapeDecoration(
                            color:
                                allCheck
                                    ? AppColors.appPurpleColor
                                    : const Color(0xFF2F1A5A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "확인",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.45,
                              ),
                            ),
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
      );
    } else {
      _goToNextStep();
    }
    // 입력값 디버그 로그 제거
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        leading: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24.w),
          ),
        ),
        title: Text(
          "본인인증",
          style: TextStyle(
            color: const Color(0xFFEBEDF0),
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 38.h),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: _buildPromptText(),
            ),
            SizedBox(height: 30.h),
            ...List.generate(_step + 1, (index) {
              switch (index) {
                case 3:
                  return Ui02LabeledInputField(
                    label: "통신사",
                    child: Login02CarrierField(
                      controller: _carrierController,
                      keyboardType: TextInputType.text,
                    ),
                  );
                case 2:
                  return Ui02LabeledInputField(
                    label: "휴대폰 번호",
                    child: Ui02AnimatedInputField(
                      visible: _step >= index,
                      child: Ui02PhoneInputField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        focusNode: _phoneFocus,
                      ),
                    ),
                  );
                case 1:
                  return Ui02AnimatedInputField(
                    visible: _step >= index,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),

                      child: Login02Birthinput(
                        frontController: _rrnFrontController,
                        backController: _rrnBackController,
                        frontFocus: _rrnFrontFocus,
                        backFocus: _rrnBackFocus,
                      ),
                    ),
                  );
                default:
                  return Ui02LabeledInputField(
                    label: "이름",
                    child: Ui02AnimatedInputField(
                      visible: _step >= index,
                      child: Login02Inputfield(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        focusNode: _nameFocus,
                      ),
                    ),
                  );
              }
            }).toList().reversed,
            Spacer(),
            GestureDetector(
              onTap: _isButtonEnabled ? _onconfirmPressed : null,
              child: Container(
                width: 342.w,
                height: 56.h,
                decoration: BoxDecoration(
                  color:
                      _isButtonEnabled
                          ? AppColors.appPurpleColor
                          : const Color(0xFF2F1A5A),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    "확인",
                    style: TextStyle(
                      color:
                          _isButtonEnabled
                              ? Colors.white
                              : Colors.white.withOpacity(0.80),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
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
