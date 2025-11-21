import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';

import 'package:vybe/core/widgets/custom_divider.dart';
import 'package:vybe/features/table_reservation_page/widgets/select_options_page/menu_info_header.dart';
import 'package:vybe/features/table_reservation_page/widgets/select_options_page/option_check_tile.dart';
import 'package:vybe/features/table_reservation_page/widgets/select_options_page/quantity_selector.dart';

/// 메뉴 옵션/수량을 선택하는 페이지.
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

  /// 금액으로 들어오는 동적 타입을 숫자로 변환한다.
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

  /// 선택한 옵션들의 추가 금액 합계.
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

  /// 옵션을 비교 가능한 키로 변환한다.
  String _optionKey(Map<String, dynamic> opt) {
    final name = (opt['name'] ?? '').toString();
    final price = _parsePrice(opt['price']);
    return '$name::$price';
  }

  /// 수량 증가
  void _increaseQuantity() {
    setState(() {
      _quantity += 1;
    });
  }

  /// 수량 감소
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
    final String menuImagePath = widget.menu['image'] as String? ?? '';
    final bool isMainMenu = widget.menu['isMain'] as bool? ?? false;
    final String menuName = widget.menu['name'] as String? ?? '';
    final String menuDescription = widget.menu['description'] as String? ?? '';
    final String menuPrice = _comma.format(_menuUnitPrice);
    final String totalPriceLabel = '${_comma.format(_orderTotalPrice)}원 담기';

    /// 전체 옵션 선택 화면 구조.
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
            fontSize: 20.sp,
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
          MenuInfoHeader(
            menuImagePath: menuImagePath,
            isMainMenu: isMainMenu,
            menuName: menuName,
            menuDescription: menuDescription,
            priceLabel: '$menuPrice원',
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
                          color: Colors.white,
                          fontSize: 20.sp,
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
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                          height: 1.10,
                          letterSpacing: -0.50,
                        ),
                      ),
                    ],
                  ),
                ),
                QuantitySelector(
                  quantity: _quantity,
                  onDecrease: _decreaseQuantity,
                  onIncrease: _increaseQuantity,
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

                    return OptionCheckTile(
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
                      fontSize: 15.sp,
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
