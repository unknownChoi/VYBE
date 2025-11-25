import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/menu_sections_list_view.dart';

class MenuOrderScreen extends StatefulWidget {
  const MenuOrderScreen({super.key, Set<CartEntry>? initialItems})
    : initialItems = initialItems ?? const <CartEntry>{};

  final Set<CartEntry> initialItems;

  @override
  State<MenuOrderScreen> createState() => _MenuOrderScreenState();
}

class _MenuOrderScreenState extends State<MenuOrderScreen> {
  /// 메뉴 안내 문구.
  static const _menuDisclaimer = '메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.';

  /// 화면에 노출할 카테고리 목록.
  late final List<String> _categories = List<String>.from(menuCategories);

  /// 사용자가 선택한 카테고리 이름.
  String? _selectedCategory;

  /// 장바구니에 저장된 메뉴 목록.
  final Set<CartEntry> _cartItems = <CartEntry>{};

  /// 숫자를 쉼표로 포매팅하기 위한 포매터.
  final NumberFormat _comma = NumberFormat('#,##0');

  /// 화면에 그릴 메뉴 섹션 캐시.
  List<MapEntry<String, List<Map<String, dynamic>>>> _menuEntries =
      <MapEntry<String, List<Map<String, dynamic>>>>[];

  /// 장바구니에 담긴 총 수량 표시를 위한 합계.
  int get _cartQuantityTotal =>
      _cartItems.fold<int>(0, (sum, entry) => sum + entry.quantity);

  /// 등록된 카테고리가 있는지 여부.
  bool get _hasCategories => _categories.isNotEmpty;

  /// 현재 장바구니 상태를 반환하며 화면을 닫는다.
  void _closeWithResult() {
    Navigator.pop(context, cloneCartItems(_cartItems));
  }

  /// 선택된 카테고리에 맞춰 메뉴 섹션을 갱신한다.
  void _syncMenuEntries() {
    _menuEntries = buildMenuEntries(
      hasCategories: _hasCategories,
      menuItemsByCategory: menuItemsData,
      selectedCategory: _selectedCategory,
    );
  }

  /// 카테고리 선택 시 상태를 갱신한다.
  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
      _syncMenuEntries();
    });
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

  @override
  void initState() {
    super.initState();
    _cartItems.addAll(cloneCartItems(widget.initialItems));
    _syncMenuEntries();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _closeWithResult();
        }
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
            onPressed: _closeWithResult,
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
                onSelect: _onCategorySelected,
              ),
            ),
            Expanded(
              child: _hasCategories
                  ? MenuSectionsListView(
                      entries: _menuEntries,
                      disclaimer: _menuDisclaimer,
                      onAddToCart: _addMenuToCart,
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
