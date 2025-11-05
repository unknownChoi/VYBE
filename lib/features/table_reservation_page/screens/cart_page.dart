import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/screens/select_options_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.items});

  final Set<CartEntry> items;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final NumberFormat _comma = NumberFormat('#,##0');

  num _parsePrice(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  num get _totalPrice =>
      widget.items.fold<num>(0, (sum, entry) => sum + entry.totalPrice);

  Widget _fallbackImage() {
    return Container(
      width: 68.w,
      height: 68.w,
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: const Icon(Icons.local_dining_outlined, color: Color(0xFF9F9FA1)),
    );
  }

  void _updateQuantity(CartEntry entry, int delta) {
    final next = entry.quantity + delta;
    if (next < 1) {
      return;
    }
    setState(() {
      entry.quantity = next;
    });
  }

  void _removeEntry(CartEntry entry) {
    setState(() {
      widget.items.remove(entry);
    });
  }

  void _closeWithResult() {
    Navigator.pop(context, Set<CartEntry>.from(widget.items));
  }

  Future<void> _onChangeOptions(CartEntry entry) async {
    final menuOptions = entry.menu['options'];
    if (menuOptions is! List || menuOptions.isEmpty) {
      return;
    }

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => SelectOptionsPage(
          menu: Map<String, dynamic>.from(entry.menu),
          options: menuOptions,
          initialSelectedOptions: entry.options
              .map((opt) => Map<String, dynamic>.from(opt))
              .toList(),
          initialQuantity: entry.quantity,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    final payload = Map<String, dynamic>.from(result);

    final int nextQuantityRaw = payload['quantity'] as int? ?? entry.quantity;
    final int nextQuantity = nextQuantityRaw < 1 ? 1 : nextQuantityRaw;
    final List<Map<String, dynamic>> selectedOptions =
        (payload['options'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((opt) => Map<String, dynamic>.from(opt))
            .toList() ??
        <Map<String, dynamic>>[];
    final num basePrice = _parsePrice(entry.menu['price']);
    final num optionsExtra = selectedOptions.fold<num>(
      0,
      (sum, opt) => sum + _parsePrice(opt['price']),
    );
    final num resultTotal =
        payload['totalPrice'] as num? ??
        (basePrice * nextQuantity + optionsExtra);
    final num nextUnitPrice = nextQuantity > 0
        ? resultTotal / nextQuantity
        : basePrice + optionsExtra;

    setState(() {
      widget.items.remove(entry);
      final updatedEntry = entry.copyWith(
        options: selectedOptions,
        quantity: nextQuantity,
        unitPrice: nextUnitPrice,
      );
      final existing = widget.items.lookup(updatedEntry);
      if (existing != null) {
        existing.quantity += updatedEntry.quantity;
      } else {
        widget.items.add(updatedEntry);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.items.toList(growable: false);

    return WillPopScope(
      onWillPop: () async {
        _closeWithResult();
        return false;
      },
      child: Scaffold(
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
              _closeWithResult();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            '장바구니',
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
        body: entries.isEmpty
            ? Center(
                child: Text(
                  '장바구니가 비어 있습니다.',
                  style: TextStyle(
                    color: const Color(0xFFECECEC),
                    fontSize: 16.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                itemCount: entries.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final optionsText = entry.options.isEmpty
                      ? '옵션 없음'
                      : entry.options
                            .map((opt) {
                              final name = opt['name']?.toString() ?? '옵션';
                              final price = _parsePrice(opt['price']);
                              if (price == 0) {
                                return name;
                              }
                              return '$name (+${_comma.format(price)}원)';
                            })
                            .join('\n');
                  final hasMenuOptions =
                      (entry.menu['options'] as List?)?.isNotEmpty ?? false;
                  final price = _comma.format(entry.unitPrice);

                  final imageWidget = entry.menuImagePath.isEmpty
                      ? SizedBox()
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.asset(
                            entry.menuImagePath,
                            width: 68.w,
                            height: 68.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _fallbackImage(),
                          ),
                        );

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 1.w,
                          color: Color(0xFF2F2F33),
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.menuName,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFFECECEC,
                                    ) /* Gray200 */,
                                    fontSize: 18,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    height: 1.11,
                                    letterSpacing: -0.90,
                                  ),
                                ),
                                SizedBox(height: 8.h),

                                Text(
                                  '추가 옵션',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFFECECEC,
                                    ) /* Gray200 */,
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    height: 1.14,
                                    letterSpacing: -0.35,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  optionsText,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFFCACACB,
                                    ) /* Gray400 */,
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    height: 1.14,
                                    letterSpacing: -0.70,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            imageWidget,
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              '$price원',
                              style: TextStyle(
                                color: const Color(0xFFECECEC) /* Gray200 */,
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                height: 1.11,
                                letterSpacing: -0.90,
                              ),
                            ),
                            Spacer(),
                            if (hasMenuOptions) ...[
                              GestureDetector(
                                onTap: () => _onChangeOptions(entry),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF404042),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '옵션 변경',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        height: 1.17,
                                        letterSpacing: -0.60,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            GestureDetector(
                              onTap: () => _removeEntry(entry),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF404042),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '삭제하기',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.17,
                                      letterSpacing: -0.60,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            CountButton(
                              width: 20,
                              height: 20,
                              svgPath: 'assets/icons/common/minus.svg',
                              onTap: () => _updateQuantity(entry, -1),
                              isEnabled: entry.quantity > 1,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "${entry.quantity}",
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
                            SizedBox(width: 8.w),
                            CountButton(
                              width: 20,
                              height: 20,
                              svgPath: 'assets/icons/common/plus.svg',
                              onTap: () => _updateQuantity(entry, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
        bottomNavigationBar: SafeArea(
          top: false,
          bottom: true,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: GestureDetector(
              onTap: () {
                _closeWithResult();
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.appPurpleColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: Text(
                    '${_comma.format(_totalPrice)}원 결제하기',
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
            ),
          ),
        ),
      ),
    );
  }
}
