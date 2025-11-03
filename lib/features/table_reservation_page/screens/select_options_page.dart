import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/widgets/custom_divider.dart';

class SelectOptionsPage extends StatefulWidget {
  final Map<String, dynamic> menu;
  final List<dynamic> options;

  const SelectOptionsPage({
    super.key,
    required this.menu,
    required this.options,
  });

  @override
  State<SelectOptionsPage> createState() => _SelectOptionsPageState();
}

class _SelectOptionsPageState extends State<SelectOptionsPage> {
  List<Map<String, dynamic>> get _optionGroups =>
      widget.options.whereType<Map<String, dynamic>>().toList();

  final _comma = NumberFormat('#,##0');

  @override
  void initState() {
    super.initState();
    print(widget.options);
    print(widget.menu);
  }

  @override
  Widget build(BuildContext context) {
    final String menuImagePath = widget.menu['image'] as String;
    final bool isMainMenu = widget.menu['isMain'] as bool;
    final String menuName = widget.menu['name'] as String;
    final String menuDescription = widget.menu['description'] as String;
    final String menuPrice = _comma.format(widget.menu['price'] as num);

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 24.w + 48.w,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          '주문하기',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 사진
          if (menuImagePath != '')
            Container(
              width: double.infinity,
              height: 160.h,
              decoration: BoxDecoration(color: Color(0XFF9F9FA1)),
              child: Center(
                child: Image.asset(
                  height: double.infinity,
                  fit: BoxFit.cover,
                  menuImagePath,
                ),
              ),
            ),
          // 메뉴 이름 + 설명
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (isMainMenu) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 4.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appPurpleColor,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Center(
                          child: Text(
                            '대표',
                            style: TextStyle(
                              color: const Color(0xFFECECEC) /* Gray200 */,
                              fontSize: 10,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.40,
                              letterSpacing: -0.50,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      menuName,
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 24,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.08,
                        letterSpacing: -0.60,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (menuDescription != '')
                  Text(
                    menuDescription,
                    style: TextStyle(
                      color: const Color(0xFF9F9FA1) /* Gray500 */,
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.12,
                      letterSpacing: -0.80,
                    ),
                  ),
              ],
            ),
          ),
          CustomDivider(),
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Text(
                        '가격',
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
                      Text(
                        "$menuPrice원",
                        style: TextStyle(
                          color: Colors.white /* White */,
                          fontSize: 20,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.10,
                          letterSpacing: -0.50,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),

                  child: Row(
                    children: [
                      Text(
                        '수량',
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
                      CountButton(svgPath: 'assets/icons/common/minus.svg'),
                      SizedBox(width: 8.w),
                      Text(
                        '1',
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
                      SizedBox(width: 8.w),
                      CountButton(svgPath: 'assets/icons/common/plus.svg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomDivider(),
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Text(
                  '추가 옵션',
                  style: TextStyle(
                    color: const Color(0xFFECECEC) /* Gray200 */,
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.11,
                    letterSpacing: -0.90,
                  ),
                ),
                SizedBox(height: 9.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CountButton extends StatelessWidget {
  const CountButton({super.key, required this.svgPath});

  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF404042),
      ),
      child: Center(child: SvgPicture.asset(width: 12.w, svgPath)),
    );
  }
}
