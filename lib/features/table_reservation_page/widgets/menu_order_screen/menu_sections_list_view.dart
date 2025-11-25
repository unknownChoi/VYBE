import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/menu_empty_message.dart';
import 'package:vybe/features/table_reservation_page/widgets/menu_order_screen/menu_section.dart';

/// 메뉴 섹션들을 한번에 스크롤할 수 있게 구성한 리스트 뷰.
class MenuSectionsListView extends StatelessWidget {
  const MenuSectionsListView({
    super.key,
    required this.entries,
    required this.disclaimer,
    required this.onAddToCart,
  });

  /// 카테고리별 메뉴 데이터.
  final List<MapEntry<String, List<Map<String, dynamic>>>> entries;

  /// 하단에 고정으로 보여줄 안내 문구.
  final String disclaimer;

  /// 메뉴 추가 요청을 상위로 전달하는 콜백.
  final ValueChanged<Map<String, dynamic>> onAddToCart;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        children: [
          const MenuEmptyMessage(),
          Text(disclaimer, style: AppTextStyles.disclaimer),
          SizedBox(height: 88.h),
        ],
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      itemCount: entries.length + 1,
      itemBuilder: (context, index) {
        final bool isDisclaimer = index == entries.length;
        if (isDisclaimer) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(disclaimer, style: AppTextStyles.disclaimer),
              SizedBox(height: 88.h),
            ],
          );
        }

        final entry = entries[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: MenuSection(
            key: ValueKey(entry.key),
            categoryName: entry.key,
            items: entry.value,
            onAddToCart: onAddToCart,
          ),
        );
      },
    );
  }
}
