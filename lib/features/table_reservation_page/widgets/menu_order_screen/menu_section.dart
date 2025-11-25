import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/features/table_reservation_page/utils/menu_order_functions.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/menu_empty_message.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/menu_section_divider.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/order_menu_item_card.dart';

/// 하나의 카테고리 내 메뉴 목록을 그려주는 섹션 위젯.
class MenuSection extends StatelessWidget {
  const MenuSection({
    super.key,
    required this.categoryName,
    required this.items,
    required this.onAddToCart,
  });

  /// 카테고리 이름.
  final String categoryName;

  /// 카테고리별 메뉴 데이터.
  final List<Map<String, dynamic>> items;

  /// 메뉴를 장바구니에 추가할 때 호출되는 콜백.
  final ValueChanged<Map<String, dynamic>> onAddToCart;

  @override
  Widget build(BuildContext context) {
    final int itemCount = items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(categoryName, style: AppTextStyles.sectionTitle),
        SizedBox(height: 16.h),
        const MenuSectionDivider(),
        if (itemCount == 0) ...[
          const MenuEmptyMessage(),
          SizedBox(height: 32.h),
        ] else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              final item = items[index];
              final description = item['description'] as String? ?? '';
              final name = item['name'] as String? ?? '이름없는 메뉴';
              final price = parseMenuPrice(item['price']).toInt();
              final image = item['image'] as String? ?? '';
              final isMain = item['isMain'] as bool? ?? false;

              return OrderMenuItemCard(
                menuName: name,
                menuPrice: price,
                menuImageSrc: image,
                isMainMenu: isMain,
                menuDescription: description,
                onAddToCart: () => onAddToCart(item),
              );
            },
            separatorBuilder: (context, index) => const MenuSectionDivider(),
          ),
          const MenuSectionDivider(),
          SizedBox(height: 32.h),
        ],
      ],
    );
  }
}
