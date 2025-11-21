import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/table_reservation_page/screens/select_options_page.dart';

import 'package:vybe/features/table_reservation_page/screens/cart_page.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/utils/menu_order_functions.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/menu_category_selector.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/menu_order_bottom_bar.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/order_menu_item_card.dart';

class MenuOrderScreen extends StatefulWidget {
  const MenuOrderScreen({super.key, Set<CartEntry>? initialItems})
    : initialItems = initialItems ?? const <CartEntry>{};

  final Set<CartEntry> initialItems;

  @override
  State<MenuOrderScreen> createState() => _MenuOrderScreenState();
}

class _MenuOrderScreenState extends State<MenuOrderScreen> {
  static const _menuDisclaimer = '메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.';

  late final List<String> _categories = List<String>.from(menuCategories);
  String? _selectedCategory;
  final Set<CartEntry> _cartItems = <CartEntry>{};
  final NumberFormat _comma = NumberFormat('#,##0');

  /// 장바구니에 담긴 총 수량 표시를 위한 합계.
  int get _cartQuantityTotal =>
      _cartItems.fold<int>(0, (sum, entry) => sum + entry.quantity);

  bool get _hasCategories => _categories.isNotEmpty;

  /// 현재 장바구니 상태를 반환하며 화면을 닫는다.
  void _closeWithResult() {
    Navigator.pop(context, cloneCartItems(_cartItems));
  }

  /// 메뉴 아이템을 장바구니에 추가하고 옵션 선택이 필요한 경우 페이지를 띄운다.
  Future<void> _addMenuToCart(Map<String, dynamic> item) async {
    final name = item['name'] as String? ?? '이름없는 메뉴';
    final options = item['options'];

    Map<String, dynamic>? selectionResult;

    if (options is List && options.isNotEmpty) {
      debugPrint('옵션 선택 필요: $name');
      selectionResult = await Navigator.of(context).push<Map<String, dynamic>>(
        MaterialPageRoute(
          builder: (_) => SelectOptionsPage(menu: item, options: options),
        ),
      );

      if (!mounted) return;
      if (selectionResult == null) {
        debugPrint('옵션 선택 취소: $name');
        return;
      }
      debugPrint('옵션 선택 완료: $name');
    }

    if (!mounted) return;

    final int quantity = selectionResult?['quantity'] as int? ?? 1;
    final List<Map<String, dynamic>> selectedOptions =
        (selectionResult?['options'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((opt) => Map<String, dynamic>.from(opt))
            .toList() ??
        <Map<String, dynamic>>[];
    final num basePrice = parseMenuPrice(item['price']);
    final num optionsExtra = selectedOptions.fold<num>(
      0,
      (sum, opt) => sum + parseMenuPrice(opt['price']),
    );
    final num totalPrice =
        selectionResult?['totalPrice'] as num? ??
        (basePrice * quantity + optionsExtra);
    final num unitPrice = quantity > 0
        ? totalPrice / quantity
        : basePrice + optionsExtra;

    final newEntry = CartEntry(
      menu: Map<String, dynamic>.from(item),
      menuName: name,
      options: selectedOptions,
      unitPrice: unitPrice,
      quantity: quantity,
      menuImagePath: (item['image'] ?? '').toString(),
    );

    int updatedQuantity = quantity;
    setState(() {
      final existing = _cartItems.lookup(newEntry);
      if (existing != null) {
        existing.quantity += quantity;
        updatedQuantity = existing.quantity;
      } else {
        _cartItems.add(newEntry);
        updatedQuantity = newEntry.quantity;
      }
    });

    final optionsLabel = selectedOptions.isEmpty
        ? '옵션 없음'
        : selectedOptions.map((opt) => opt['name']).join(', ');
    debugPrint('Added to cart: $name x$updatedQuantity ($optionsLabel)');
  }

  /// 장바구니를 열어 변경된 항목이 있으면 현재 상태에 반영한다.
  Future<void> _printCartItems() async {
    debugPrint('장바구니 메뉴: ${cartSummary(_cartItems, formatter: _comma)}');

    final updatedItems = await Navigator.push<Set<CartEntry>>(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(items: cloneCartItems(_cartItems)),
      ),
    );

    if (!mounted) {
      return;
    }

    if (updatedItems != null) {
      setState(() {
        _cartItems
          ..clear()
          ..addAll(cloneCartItems(updatedItems));
      });
      debugPrint(
        '장바구니 메뉴 (업데이트): ${cartSummary(_cartItems, formatter: _comma)}',
      );
    }
  }

  /// 현재 선택된 카테고리에 맞춰 메뉴 섹션을 구성한다.
  List<Widget> _buildMenuSections() {
    final entries = buildMenuEntries(
      hasCategories: _hasCategories,
      menuItemsByCategory: menuItemsData,
      selectedCategory: _selectedCategory,
    );
    if (entries.isEmpty) {
      return [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text('등록된 메뉴가 없습니다.', style: AppTextStyles.subtitle),
        ),
      ];
    }

    final widgets = <Widget>[];
    for (final entry in entries) {
      final category = entry.key;
      final items = entry.value;

      widgets
        ..add(Text(category, style: AppTextStyles.sectionTitle))
        ..add(SizedBox(height: 16.h))
        ..add(
          Divider(height: 1.h, thickness: 1.h, color: const Color(0xFF404042)),
        );

      if (items.isEmpty) {
        widgets
          ..add(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text('등록된 메뉴가 없습니다.', style: AppTextStyles.subtitle),
            ),
          )
          ..add(SizedBox(height: 32.h));
        continue;
      }

      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final description = item['description'] as String? ?? '';
        widgets.add(
          OrderMenuItemCard(
            menuName: item['name'] as String,
            menuPrice: item['price'] as int,
            menuImageSrc: item['image'] as String,
            isMainMenu: item['isMain'] as bool,
            menuDescription: description,
            onAddToCart: () {
              _addMenuToCart(item);
            },
          ),
        );

        final isLastItem = i == items.length - 1;
        widgets.add(
          Divider(height: 1.h, thickness: 1.h, color: const Color(0xFF404042)),
        );
        if (isLastItem) {
          widgets.add(SizedBox(height: 32.h));
        }
      }
    }
    return widgets;
  }

  @override
  void initState() {
    super.initState();
    _cartItems.addAll(cloneCartItems(widget.initialItems));
  }

  @override
  Widget build(BuildContext context) {
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
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: MenuCategorySelector(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onSelect: (category) {
                  setState(() => _selectedCategory = category);
                },
              ),
            ),
            Expanded(
              child: _hasCategories
                  ? ListView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 8.h,
                      ),
                      children: [
                        ..._buildMenuSections(),
                        Text(_menuDisclaimer, style: AppTextStyles.disclaimer),
                        SizedBox(height: 88.h),
                      ],
                    )
                  : Center(
                      child: Text(
                        '메뉴 카테고리가 없습니다.',
                        style: AppTextStyles.subtitle,
                      ),
                    ),
            ),
          ],
        ),
        bottomNavigationBar: MenuOrderBottomBar(
          onOpenCart: _printCartItems,
          cartCount: _cartQuantityTotal,
          onConfirm: _closeWithResult,
        ),
      ),
    );
  }
}
