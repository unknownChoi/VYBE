import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

/// Single agreement checkbox entry.
class AgreementItem {
  const AgreementItem({
    required this.id,
    required this.title,
    required this.isRequired,
  });

  final String id;
  final String title;
  final bool isRequired;
}

/// Reusable agreement selector block used on the purchase page.
class PurchaseAgreementSection extends StatelessWidget {
  const PurchaseAgreementSection({
    super.key,
    required this.items,
    required this.checkedIds,
    required this.onToggleItem,
    required this.onToggleAll,
  });

  final List<AgreementItem> items;
  final Set<String> checkedIds;
  final ValueChanged<String> onToggleItem;
  final ValueChanged<bool> onToggleAll;

  bool get _isAllChecked =>
      items.isNotEmpty && checkedIds.length == items.length;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final bool isAllChecked = _isAllChecked;

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => onToggleAll(!isAllChecked),
            borderRadius: BorderRadius.circular(8.r),
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
            child: Row(
              children: [
                _buildSelectBox(isAllChecked),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    '전체 동의하기',
                    style: TextStyle(
                      color: const Color(0xFFECECEC),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.12,
                      letterSpacing: -0.80,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Container(height: 1, color: const Color(0xFF2F2F33)),
          SizedBox(height: 16.h),
          for (int i = 0; i < items.length; i++) ...[
            _AgreementTile(
              item: items[i],
              checked: checkedIds.contains(items[i].id),
              onTap: () => onToggleItem(items[i].id),
            ),
            if (i < items.length - 1) SizedBox(height: 12.h),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectBox(bool checked) {
    return Container(
      width: 16.w,
      height: 16.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        border: Border.all(
          width: 1.w,
          color: checked ? AppColors.appGreenColor : const Color(0xFF535355),
        ),
      ),
      child: checked
          ? Icon(Icons.check, color: AppColors.appGreenColor, size: 14.sp)
          : null,
    );
  }
}

class _AgreementTile extends StatelessWidget {
  const _AgreementTile({
    required this.item,
    required this.checked,
    required this.onTap,
  });

  final AgreementItem item;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = checked
        ? AppColors.appGreenColor
        : const Color(0xFF535355);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      child: Row(
        children: [
          Icon(Icons.check, size: 18.sp, color: iconColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                text: item.title,
                style: TextStyle(
                  color: const Color(0xFFECECEC),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.20,
                  letterSpacing: -0.35,
                ),
                children: [
                  TextSpan(
                    text: '  (${item.isRequired ? '필수' : '선택'})',
                    style: TextStyle(
                      color: const Color(0xFF9F9FA1),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                      letterSpacing: -0.33,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: const Color(0xFF535355),
            size: 18.sp,
          ),
        ],
      ),
    );
  }
}
