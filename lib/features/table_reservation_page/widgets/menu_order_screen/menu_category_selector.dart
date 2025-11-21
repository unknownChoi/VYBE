import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/features/club_detail_page/widgets/atoms/category_chip.dart';

/// Horizontal scrollable category selector used on the menu order screen.
class MenuCategorySelector extends StatelessWidget {
  const MenuCategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
  });

  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map(
              (category) => GestureDetector(
                onTap: () {
                  if (selectedCategory == category) {
                    onSelect(null);
                  } else {
                    onSelect(category);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: CategoryChip(
                    category: category,
                    isSelected: selectedCategory == category,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
