import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/club_detail_page/widgets/category_chip.dart';
import 'package:vybe/features/club_detail_page/widgets/custom_divider.dart';
import 'package:vybe/features/club_detail_page/widgets/menu_item_card.dart';
import 'package:vybe/features/club_detail_page/widgets/sections/club_image_area.dart';

class MenuTab extends StatelessWidget {
  final Map<String, GlobalKey> categoryKeys;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  final GlobalKey? topKey;

  const MenuTab({
    required this.categoryKeys,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.topKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          key: topKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubImageArea(
              images: clubData['menuImages']! as List<String>,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: CustomDivider()),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100.h,
            child: Center(
              child: SizedBox(
                height: 35.h,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: menuCategories.length,
                  itemBuilder: (context, index) {
                    final category = menuCategories[index];
                    return GestureDetector(
                      onTap: () => onCategorySelected(category),
                      child: CategoryChip(
                        category: category,
                        isSelected: selectedCategory == category,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        ...menuItemsData.entries.expand((entry) {
          final category = entry.key;
          final items = entry.value;
          if (items.isEmpty) return <Widget>[];

          return [
            SliverToBoxAdapter(
              key: categoryKeys[category],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Text(category, style: AppTextStyles.sectionTitle),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Divider(
                  height: 1.h,
                  thickness: 1.h,
                  color: const Color(0xFF404042),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = items[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      MenuItemCard(
                        menuName: item["name"] as String,
                        menuPrice: item["price"] as int,
                        menuImageSrc: item["image"] as String,
                        isMainMenu: item["isMain"] as bool,
                      ),
                      Divider(
                        height: 1.h,
                        thickness: 1.h,
                        color: const Color(0xFF404042),
                      ),
                    ],
                  ),
                );
              }, childCount: items.length),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          ];
        }),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              '메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.',
              style: AppTextStyles.disclaimer,
            ),
          ),
        ),
      ],
    );
  }
}
