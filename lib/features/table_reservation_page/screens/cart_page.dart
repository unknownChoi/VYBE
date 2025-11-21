import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/screens/select_options_page.dart';
import 'package:vybe/features/table_reservation_page/widgets/cart_items_list_view.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.items});

  final Set<CartEntry> items;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final NumberFormat _comma = NumberFormat('#,##0');

  /// 메뉴와 옵션에 포함된 동적 값을 숫자 금액으로 변환한다.
  num _parsePrice(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// 현재 장바구니 내 모든 항목의 총 금액을 계산한다.
  num get _totalPrice =>
      widget.items.fold<num>(0, (sum, entry) => sum + entry.totalPrice);

  /// 선택한 항목의 수량을 증감하고 최소 수량 제한을 적용한다.
  void _updateQuantity(CartEntry entry, int delta) {
    final next = entry.quantity + delta;
    if (next < 1) {
      return;
    }
    setState(() {
      entry.quantity = next;
    });
  }

  /// 장바구니에서 특정 항목을 제거한다.
  void _removeEntry(CartEntry entry) {
    setState(() {
      widget.items.remove(entry);
    });
  }

  /// 장바구니의 최신 상태를 반환하며 화면을 닫는다.
  void _closeWithResult() {
    Navigator.pop(context, Set<CartEntry>.from(widget.items));
  }

  /// 옵션 선택 화면을 호출해 항목 옵션·수량 변경 후 장바구니 상태를 갱신한다.
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.appBackgroundColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 24.w + 48.w,
      leading: IconButton(
        onPressed: _closeWithResult,
        icon: const Icon(Icons.arrow_back_ios),
      ),
      title: Text(
        '장바구니',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          height: 1.10,
          letterSpacing: -0.50,
        ),
      ),
    );
  }

  Widget _buildBody(List<CartEntry> entries) {
    if (entries.isEmpty) {
      return Center(
        child: Text(
          '장바구니가 비어 있습니다.',
          style: TextStyle(
            color: const Color(0xFFECECEC),
            fontSize: 16.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
    return CartItemsListView(
      entries: entries,
      onUpdateQuantity: _updateQuantity,
      onRemoveEntry: _removeEntry,
      onChangeOptions: _onChangeOptions,
    );
  }

  Widget _buildCheckoutButton() {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: GestureDetector(
          onTap: _closeWithResult,
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
                  fontSize: 15.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 장바구니 UI를 구성하며 항목 유무에 따라 다른 화면을 보여준다.
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
        appBar: _buildAppBar(),
        body: _buildBody(entries),
        bottomNavigationBar: _buildCheckoutButton(),
      ),
    );
  }
}
