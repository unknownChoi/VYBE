import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';

import 'package:vybe/core/widgets/custom_divider.dart';

class SelectOptionsPage extends StatefulWidget {
  final Map<String, dynamic> menu;
  final List<dynamic> options;
  final List<Map<String, dynamic>> initialSelectedOptions;
  final int initialQuantity;

  const SelectOptionsPage({
    super.key,
    required this.menu,
    required this.options,
    this.initialSelectedOptions = const [],
    this.initialQuantity = 1,
  });

  @override
  State<SelectOptionsPage> createState() => _SelectOptionsPageState();
}

class _SelectOptionsPageState extends State<SelectOptionsPage> {
  final _comma = NumberFormat('#,##0');
  late int _quantity;

  final Set<int> _selectedOptionIndexes = {};
  List<Map<String, dynamic>> get _options =>
      widget.options.whereType<Map<String, dynamic>>().toList();

  List<Map<String, dynamic>> get _selectedOptions {
    final options = _options;
    return _selectedOptionIndexes
        .where((index) => index >= 0 && index < options.length)
        .map((index) => Map<String, dynamic>.from(options[index]))
        .toList();
  }

  num _parsePrice(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  num get _menuUnitPrice => _parsePrice(widget.menu['price']);

  num get _selectedOptionsPrice {
    num total = 0;
    final options = _options;
    for (final index in _selectedOptionIndexes) {
      if (index >= 0 && index < options.length) {
        total += _parsePrice(options[index]['price']);
      }
    }
    return total;
  }

  num get _menuTotalPrice => _menuUnitPrice * _quantity;

  num get _orderTotalPrice => _menuTotalPrice + _selectedOptionsPrice;

  String _optionKey(Map<String, dynamic> opt) {
    final name = (opt['name'] ?? '').toString();
    final price = _parsePrice(opt['price']);
    return '$name::$price';
  }

  void _increaseQuantity() {
    setState(() {
      _quantity += 1;
    });
  }

  void _decreaseQuantity() {
    if (_quantity == 1) {
      return;
    }
    setState(() {
      _quantity -= 1;
    });
  }

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity > 0 ? widget.initialQuantity : 1;

    final initialKeys = widget.initialSelectedOptions
        .map((opt) => _optionKey(opt))
        .toSet();
    final options = _options;
    for (var i = 0; i < options.length; i++) {
      final option = options[i];
      if (initialKeys.contains(_optionKey(option))) {
        _selectedOptionIndexes.add(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String menuImagePath = widget.menu['image'] as String;
    final bool isMainMenu = widget.menu['isMain'] as bool;
    final String menuName = widget.menu['name'] as String;
    final String menuDescription = widget.menu['description'] as String;
    final String menuPrice = _comma.format(_menuUnitPrice);
    final String totalPriceLabel = '${_comma.format(_orderTotalPrice)}원 담기';

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
            Navigator.pop(context);
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
                      CountButton(
                        width: 32,
                        height: 32,

                        svgPath: 'assets/icons/common/minus.svg',
                        onTap: _decreaseQuantity,
                        isEnabled: _quantity > 1,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '$_quantity',
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
                      CountButton(
                        width: 32,
                        height: 32,

                        svgPath: 'assets/icons/common/plus.svg',
                        onTap: _increaseQuantity,
                      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                // 옵션 리스트
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _options.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final opt = _options[index];
                    final name = (opt['name'] ?? '').toString();
                    final priceNum = _parsePrice(opt['price']);
                    final priceLabel = priceNum == 0
                        ? '무료'
                        : '+ ${_comma.format(priceNum)}원';
                    final checked = _selectedOptionIndexes.contains(index);

                    return _OptionCheckTile(
                      checked: checked,
                      label: name,
                      trailingPrice: priceLabel,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _selectedOptionIndexes.add(index);
                          } else {
                            _selectedOptionIndexes.remove(index);
                          }
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 40.h,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context, {
                'menu': widget.menu,
                'quantity': _quantity,
                'options': _selectedOptions,
                'totalPrice': _orderTotalPrice,
              });
            },
            child: Container(
              width: double.infinity,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppColors.appPurpleColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 40.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    totalPriceLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountButton extends StatelessWidget {
  const CountButton({
    super.key,
    required this.svgPath,
    this.onTap,
    this.isEnabled = true,
    required this.width,
    required this.height,
  });

  final String svgPath;
  final VoidCallback? onTap;
  final bool isEnabled;

  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEnabled ? Color(0xFF404042) : Color(0xFF2C2C2E),
        ),
        child: Center(
          child: SvgPicture.asset(
            width: 12.w,
            svgPath,
            colorFilter: isEnabled
                ? null
                : const ColorFilter.mode(Color(0xFF6C6C70), BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

class _OptionCheckTile extends StatelessWidget {
  const _OptionCheckTile({
    required this.checked,
    required this.label,
    required this.trailingPrice,
    required this.onChanged,
  });

  final bool checked;
  final String label;
  final String trailingPrice;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!checked),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              height: 20.h,
              child: Checkbox(
                value: checked,
                onChanged: onChanged,
                side: BorderSide(color: Color(0xFFCACACB), width: 1.w),
                fillColor: WidgetStateProperty.resolveWith(
                  (states) => states.contains(WidgetState.selected)
                      ? AppColors.appGreenColor
                      : Colors.transparent,
                ),
                checkColor: AppColors.appBackgroundColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: const Color(0xFFECECEC) /* Gray200 */,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.12,
                  letterSpacing: -0.80,
                ),
              ),
            ),
            Text(
              trailingPrice,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.12,
                letterSpacing: -0.80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
