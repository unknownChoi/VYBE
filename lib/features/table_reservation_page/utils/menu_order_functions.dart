import 'package:intl/intl.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';

/// 메뉴 원본 데이터를 안전하게 List<Map<String, dynamic>> 형태로 변환한다.
List<Map<String, dynamic>> castMenuList(dynamic raw) {
  if (raw is List<Map<String, dynamic>>) {
    return raw;
  }
  if (raw is List) {
    return raw.cast<Map<String, dynamic>>();
  }
  return [];
}

/// 메뉴·옵션에 포함된 동적 금액 값을 number 타입으로 변환한다.
num parseMenuPrice(dynamic value) {
  if (value is num) {
    return value;
  }
  if (value is String) {
    return num.tryParse(value) ?? 0;
  }
  return 0;
}

/// 장바구니 항목을 깊은 복사해 독립적인 Set으로 반환한다.
Set<CartEntry> cloneCartItems(Iterable<CartEntry> items) =>
    items.map((entry) => entry.copyWith()).toSet();

/// 장바구니 항목들을 사람이 읽기 쉬운 문자열로 요약한다.
String cartSummary(Iterable<CartEntry> items, {NumberFormat? formatter}) {
  if (items.isEmpty) {
    return '비어 있음';
  }
  final priceFormatter = formatter ?? NumberFormat('#,##0');
  return items
      .map((entry) {
        final optionsLabel = entry.options.isEmpty
            ? ''
            : ' (${entry.options.map((opt) => opt['name']).join(', ')})';
        final priceLabel = '${priceFormatter.format(entry.totalPrice)}원';
        return '${entry.menuName} x${entry.quantity} $priceLabel$optionsLabel';
      })
      .join(', ');
}

/// 선택된 카테고리에 맞춰 노출할 메뉴 목록을 구성한다.
List<MapEntry<String, List<Map<String, dynamic>>>> buildMenuEntries({
  required bool hasCategories,
  required Map<String, dynamic> menuItemsByCategory,
  String? selectedCategory,
}) {
  if (!hasCategories) {
    return [];
  }

  if (selectedCategory == null) {
    return menuItemsByCategory.entries
        .map((entry) => MapEntry(entry.key, castMenuList(entry.value)))
        .toList();
  }

  final selectedItems = menuItemsByCategory[selectedCategory];
  if (selectedItems == null) {
    return [];
  }

  return [MapEntry(selectedCategory, castMenuList(selectedItems))];
}
