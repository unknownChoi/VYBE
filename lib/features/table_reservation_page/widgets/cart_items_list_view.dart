import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/screens/select_options_page.dart';

class CartItemsListView extends StatelessWidget {
  CartItemsListView({
    super.key,
    required this.entries,
    this.onUpdateQuantity,
    this.onRemoveEntry,
    this.onChangeOptions,
    this.readOnly = false,
    EdgeInsetsGeometry? padding,
    this.physics,
    this.shrinkWrap = false,
  }) : padding =
           padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h);

  final List<CartEntry> entries;
  final void Function(CartEntry entry, int delta)? onUpdateQuantity;
  final void Function(CartEntry entry)? onRemoveEntry;
  final void Function(CartEntry entry)? onChangeOptions;
  final bool readOnly;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  static final NumberFormat _comma = NumberFormat('#,##0');

  bool _hasMenuOptions(dynamic rawOptions) {
    if (rawOptions is List) {
      for (final option in rawOptions) {
        if (option is Map<String, dynamic> && option.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
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

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
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
        final hasMenuOptions = _hasMenuOptions(entry.menu['options']);
        final price = _comma.format(entry.unitPrice);

        final imageWidget = entry.menuImagePath.isEmpty
            ? const SizedBox()
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

        final trailingActions = <Widget>[];
        void addAction(Widget widget) {
          if (trailingActions.isNotEmpty) {
            trailingActions.add(SizedBox(width: 8.w));
          }
          trailingActions.add(widget);
        }

        if (hasMenuOptions) {
          addAction(
            GestureDetector(
              onTap: () => onChangeOptions?.call(entry),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(width: 1, color: const Color(0xFF404042)),
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
          );
        }

        final showDelete = !readOnly && onRemoveEntry != null;
        if (showDelete) {
          addAction(
            GestureDetector(
              onTap: () => onRemoveEntry?.call(entry),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(width: 1, color: const Color(0xFF404042)),
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
          );
        }

        addAction(
          CountButton(
            width: 20,
            height: 20,
            svgPath: 'assets/icons/common/minus.svg',
            onTap: () => onUpdateQuantity?.call(entry, -1),
            isEnabled: entry.quantity > 1,
          ),
        );
        addAction(
          Text(
            '${entry.quantity}',
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
        );
        addAction(
          CountButton(
            width: 20,
            height: 20,
            svgPath: 'assets/icons/common/plus.svg',
            onTap: () => onUpdateQuantity?.call(entry, 1),
          ),
        );

        return Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.w, color: const Color(0xFF2F2F33)),
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
                          color: const Color(0xFFECECEC) /* Gray200 */,
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
                          color: const Color(0xFFECECEC) /* Gray200 */,
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
                          color: const Color(0xFFCACACB) /* Gray400 */,
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.14,
                          letterSpacing: -0.70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
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
                  const Spacer(),
                  ...trailingActions,
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
