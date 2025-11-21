import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodOption {
  const PaymentMethodOption({
    required this.id,
    required this.displayName,
    this.label,
    this.assetPath,
    this.wrapAsset = false,
  });

  final String id;
  final String displayName;
  final String? label;
  final String? assetPath;
  final bool wrapAsset;
}

typedef PaymentSelectCallback = void Function(PaymentMethodOption option);

class PaymentMethodGrid extends StatelessWidget {
  const PaymentMethodGrid({
    super.key,
    required this.rows,
    required this.selectedId,
    required this.onSelect,
  });

  final List<List<PaymentMethodOption>> rows;
  final String? selectedId;
  final PaymentSelectCallback onSelect;

  @override
  /// Builds the widget for context).
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows.length, (rowIndex) {
        final row = rows[rowIndex];
        return Padding(
          padding: EdgeInsets.only(bottom: rowIndex < rows.length - 1 ? 4.h : 0),
          child: Row(
            children: [
              for (int i = 0; i < row.length; i++) ...[
                Expanded(child: _PaymentTile(option: row[i], isSelected: selectedId == row[i].id, onSelect: onSelect)),
                if (i < row.length - 1) SizedBox(width: 4.w),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({required this.option, required this.isSelected, required this.onSelect});

  final PaymentMethodOption option;
  final bool isSelected;
  final PaymentSelectCallback onSelect;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (option.assetPath != null) {
      final image = Image.asset(option.assetPath!);
      child = option.wrapAsset
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: image,
            )
          : image;
    } else if (option.label != null) {
      child = Text(
        option.label!,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFECECEC),
          fontSize: 16.sp,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          height: 1.12,
          letterSpacing: -0.80,
        ),
      );
    } else {
      child = const SizedBox();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6.r),
        onTap: () => onSelect(option),
        child: Container(
          height: 68.h,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2F1A5A) : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              width: 1,
              color: isSelected ? const Color(0xFF7731FE) : const Color(0xFF2F2F33),
            ),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}