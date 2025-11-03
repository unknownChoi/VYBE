import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/club_detail_page/widgets/atoms/category_chip.dart';
import 'package:vybe/features/table_reservation_page/screens/select_options_page.dart';

import 'package:vybe/features/table_reservation_page/screens/cart_page.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';

class MenuOrderScreen extends StatefulWidget {
  const MenuOrderScreen({super.key});

  @override
  State<MenuOrderScreen> createState() => _MenuOrderScreenState();
}

class _MenuOrderScreenState extends State<MenuOrderScreen> {
  static const _menuDisclaimer = '메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.';

  late final List<String> _categories = List<String>.from(menuCategories);
  String? _selectedCategory;
  final Set<CartEntry> _cartItems = <CartEntry>{};
  final NumberFormat _comma = NumberFormat('#,##0');

  int get _cartQuantityTotal =>
      _cartItems.fold<int>(0, (sum, entry) => sum + entry.quantity);

  bool get _hasCategories => _categories.isNotEmpty;

  List<Map<String, dynamic>> _castMenuList(dynamic raw) {
    if (raw is List<Map<String, dynamic>>) {
      return raw;
    }
    if (raw is List) {
      return raw.cast<Map<String, dynamic>>();
    }
    return [];
  }

  List<MapEntry<String, List<Map<String, dynamic>>>> _resolveMenuEntries() {
    if (!_hasCategories) {
      return [];
    }

    final target = _selectedCategory;
    if (target == null) {
      return menuItemsData.entries
          .map((entry) => MapEntry(entry.key, _castMenuList(entry.value)))
          .toList();
    }

    final selectedItems = menuItemsData[target];
    if (selectedItems == null) {
      return [];
    }

    return [MapEntry(target, _castMenuList(selectedItems))];
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
    final num basePrice = _parsePrice(item['price']);
    final num optionsExtra = selectedOptions.fold<num>(
      0,
      (sum, opt) => sum + _parsePrice(opt['price']),
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

  void _printCartItems() {
    final summary = _cartItems
        .map((entry) {
          final optionsLabel = entry.options.isEmpty
              ? ''
              : ' (${entry.options.map((opt) => opt['name']).join(', ')})';
          final priceLabel = '${_comma.format(entry.totalPrice)}원';
          return '${entry.menuName} x${entry.quantity} $priceLabel$optionsLabel';
        })
        .join(', ');
    debugPrint('장바구니 메뉴: $summary');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CartPage(items: Set<CartEntry>.from(_cartItems)),
      ),
    );
  }

  List<Widget> _buildMenuSections() {
    final entries = _resolveMenuEntries();
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
    // TODO: implement initState
    super.initState();
    print(_printCartItems);
  }

  @override
  Widget build(BuildContext context) {
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
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: _hasCategories
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories
                          .map(
                            (category) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedCategory == category) {
                                    _selectedCategory = null;
                                  } else {
                                    _selectedCategory = category;
                                  }
                                });
                              },
                              child: CategoryChip(
                                category: category,
                                isSelected: _selectedCategory == category,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : const SizedBox.shrink(),
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
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 40.h,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _printCartItems,
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.appPurpleColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 11.h,
                      horizontal: 40.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '장바구니',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            final curved = CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutBack,
                            );
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: curved,
                                child: child,
                              ),
                            );
                          },
                          child: _cartItems.isNotEmpty
                              ? Padding(
                                  key: ValueKey<int>(_cartQuantityTotal),
                                  padding: EdgeInsets.only(left: 8.w),
                                  child: Container(
                                    width: 24.w,
                                    height: 24.w,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF622ACF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$_cartQuantityTotal',
                                        style: TextStyle(
                                          color: const Color(
                                            0xFFECECEC,
                                          ) /* Gray200 */,
                                          fontSize: 11.sp,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w600,
                                          height: 1.10,
                                          letterSpacing: -0.55,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  key: ValueKey('cart-count-empty'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.appPurpleColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 11.h,
                    horizontal: 40.w,
                  ),
                  child: Center(
                    child: Text(
                      '결제하기',
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
            ],
          ),
        ),
      ),
    );
  }
}

class OrderMenuItemCard extends StatelessWidget {
  final String menuName;
  final int menuPrice;
  final String menuImageSrc;
  final bool isMainMenu;
  final String menuDescription;
  final VoidCallback onAddToCart;

  const OrderMenuItemCard({
    super.key,
    required this.menuName,
    required this.menuPrice,
    required this.menuImageSrc,
    required this.menuDescription,
    required this.isMainMenu,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat wonFormat = NumberFormat('#,###');

    // 사이즈 토큰(반응형)
    final double cardHeight = 124.h;
    final double verticalPadding = 12.h;
    final double imageSize = 100.w; // 정사각
    final double imageRadius = 8.r;
    final double badgeSize = 32.w;
    final double badgeInsetRight = 6.w;
    final double badgeInsetBottom = 6.h;

    return SizedBox(
      height: cardHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 좌측 정보 영역
            Expanded(
              child: _MenuInfo(
                isMainMenu: isMainMenu,
                menuName: menuName,
                menuDescription: menuDescription,
                priceText: '${wonFormat.format(menuPrice)}원',
              ),
            ),
            // 우측 이미지 or 카트 배지
            if (menuImageSrc.isNotEmpty)
              _MenuImageWithBadge(
                imagePath: menuImageSrc,
                imageSize: imageSize,
                radius: imageRadius,
                badgeSize: badgeSize,
                badgeRight: badgeInsetRight,
                badgeBottom: badgeInsetBottom,
                onTap: onAddToCart,
              )
            else
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: GestureDetector(
                  onTap: onAddToCart,
                  child: _CartBadge(size: badgeSize),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 좌측 텍스트 정보 영역
class _MenuInfo extends StatelessWidget {
  final bool isMainMenu;
  final String menuName;
  final String menuDescription;
  final String priceText;

  const _MenuInfo({
    required this.isMainMenu,
    required this.menuName,
    required this.menuDescription,
    required this.priceText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isMainMenu)
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.appPurpleColor,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text('대표', style: AppTextStyles.representative),
                ),
              ),
            Text(menuName, style: AppTextStyles.body),
          ],
        ),
        SizedBox(height: 8.h),
        if (menuDescription.isNotEmpty)
          Text(
            menuDescription,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF9F9FA1), // Gray500
              fontSize: 12.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.17,
              letterSpacing: -0.30.w,
            ),
          ),
        SizedBox(height: 12.h),
        Text(priceText, style: AppTextStyles.price),
      ],
    );
  }
}

/// 우측 이미지 + 우하단 배지
class _MenuImageWithBadge extends StatelessWidget {
  final String imagePath;
  final double imageSize;
  final double radius;
  final double badgeSize;
  final double badgeRight;
  final double badgeBottom;
  final VoidCallback onTap;

  const _MenuImageWithBadge({
    required this.imagePath,
    required this.imageSize,
    required this.radius,
    required this.badgeSize,
    required this.badgeRight,
    required this.badgeBottom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              width: imageSize,
              height: imageSize, // 정사각형 유지
              fit: BoxFit.cover,
            ),
            Positioned(
              right: badgeRight,
              bottom: badgeBottom,
              child: GestureDetector(
                onTap: onTap,
                child: _CartBadge(size: badgeSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 공통 카트 동그라미 배지
class _CartBadge extends StatelessWidget {
  final double size;

  const _CartBadge({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.symmetric(
        vertical: (size * 0.09).clamp(2.0, 8.0), // 비율 기반 패딩(반응형)
        horizontal: (size * 0.19).clamp(4.0, 12.0),
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF404042),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/table_reservation_page/cart.svg',
          // 크기 자동 맞춤을 원하면 width/height 지정 생략
        ),
      ),
    );
  }
}
