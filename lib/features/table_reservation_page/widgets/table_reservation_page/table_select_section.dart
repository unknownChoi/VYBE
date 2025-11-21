import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_colors.dart';

/// 테이블 배치와 선택 기능을 제공하는 섹션.
class TableSelectSection extends StatelessWidget {
  const TableSelectSection({
    super.key,
    required this.selectedTableId,
    required this.soldTableIds,
    required this.onTableTap,
  });

  final String? selectedTableId;
  final Set<String> soldTableIds;
  final ValueChanged<String> onTableTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          const _TableLegend(),
          SizedBox(height: 24.h),
          _TableGrid(
            selectedTableId: selectedTableId,
            soldTableIds: soldTableIds,
            onTableTap: onTableTap,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _TableLegend extends StatelessWidget {
  const _TableLegend();

  @override
  Widget build(BuildContext context) {
    Widget buildRow(Color color, String label, List<String> details) {
      final textStyle = TextStyle(
        color: const Color(0xFFECECEC),
        fontSize: 14.sp,
        fontFamily: 'Pretendard',
        fontWeight: FontWeight.w400,
        height: 1.14,
        letterSpacing: -0.70,
      );

      return Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(label, style: textStyle),
          for (final detail in details) ...[
            SizedBox(width: 4.w),
            SvgPicture.asset(
              'assets/icons/common/dot.svg',
              width: 2.w,
              color: const Color(0xFFD9D9D9),
            ),
            SizedBox(width: 4.w),
            Text(detail, style: textStyle),
          ],
        ],
      );
    }

    return Container(
      padding: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.w, color: const Color(0xFF2F2F33)),
        ),
      ),
      child: Column(
        children: [
          buildRow(AppColors.appPurpleColor, '룸', ['4명 이상', '최소 주문 ₩150,000']),
          SizedBox(height: 8.h),
          buildRow(AppColors.appGreenColor, '테이블', ['2명 이상', '최소 주문 ₩100,000']),
          SizedBox(height: 8.h),
          buildRow(const Color(0xFFCACACB), '판매완료', ['다른 테이블을 선택해주세요.']),
        ],
      ),
    );
  }
}

class _TableGrid extends StatelessWidget {
  const _TableGrid({
    required this.selectedTableId,
    required this.soldTableIds,
    required this.onTableTap,
  });

  final String? selectedTableId;
  final Set<String> soldTableIds;
  final ValueChanged<String> onTableTap;

  @override
  Widget build(BuildContext context) {
    final rows = _tableMetaRows();
    return FittedBox(
      alignment: Alignment.topLeft,
      fit: BoxFit.scaleDown,
      child: Column(
        children: [
          for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (
                  var columnIndex = 0;
                  columnIndex < rows[rowIndex].length;
                  columnIndex++
                ) ...[
                  if (columnIndex > 0) SizedBox(width: 10.w),
                  _TableButton(
                    meta: rows[rowIndex][columnIndex],
                    isSelected:
                        selectedTableId == rows[rowIndex][columnIndex].id,
                    isSold: soldTableIds.contains(
                      rows[rowIndex][columnIndex].id,
                    ),
                    onTap: onTableTap,
                  ),
                ],
              ],
            ),
            if (rowIndex < rows.length - 1) SizedBox(height: 6.h),
          ],
        ],
      ),
    );
  }

  List<List<_TableMeta>> _tableMetaRows() {
    _TableMeta room(String id, {int quarterTurns = 0}) => _TableMeta(
      id: id,
      assetPath: 'assets/icons/table_reservation_page/table_room.svg',
      width: 52.w,
      height: 41.h,
      category: _TableCategory.room,
      quarterTurns: quarterTurns,
    );

    _TableMeta table(String id) => _TableMeta(
      id: id,
      assetPath: 'assets/icons/table_reservation_page/table.svg',
      width: 52.w,
      height: 40.h,
      category: _TableCategory.table,
      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
    );

    return [
      [
        room('1'),
        room('2', quarterTurns: 2),
        room('3'),
        room('4'),
        room('5'),
        room('6'),
      ],
      [room('7'), room('8'), room('9'), room('10'), room('11'), room('12')],
      [room('13'), room('14'), room('15'), room('16'), room('17'), room('18')],
      [table('19'), table('20'), table('21'), table('22')],
      [table('23'), table('24'), table('25'), table('26')],
      [table('27'), table('28'), table('29'), table('30')],
    ];
  }
}

class _TableButton extends StatelessWidget {
  const _TableButton({
    required this.meta,
    required this.isSelected,
    required this.isSold,
    required this.onTap,
  });

  final _TableMeta meta;
  final bool isSelected;
  final bool isSold;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = meta.category == _TableCategory.room
        ? AppColors.appPurpleColor
        : AppColors.appGreenColor;
    final Color iconColor = isSold ? const Color(0xFFCACACB) : baseColor;

    double borderWidth = 0;
    Color borderColor = Colors.transparent;
    Color backgroundColor = Colors.transparent;

    if (isSold) {
      borderWidth = 1.w;
      borderColor = const Color(0xFFCACACB);
    } else if (isSelected) {
      borderWidth = 2.w;
      borderColor = baseColor;
      backgroundColor = baseColor.withOpacity(0.18);
    } else if (meta.category == _TableCategory.room) {
      borderWidth = 1.w;
      borderColor = baseColor;
    }

    final widget = Container(
      padding:
          meta.padding ?? EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
        border: borderWidth > 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: Opacity(
        opacity: isSold ? 0.55 : 1,
        child: SvgPicture.asset(
          meta.assetPath,
          width: meta.width,
          height: meta.height,
          color: iconColor,
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(meta.id),
      child: meta.quarterTurns == 0
          ? widget
          : RotatedBox(quarterTurns: meta.quarterTurns, child: widget),
    );
  }
}

enum _TableCategory { room, table }

class _TableMeta {
  const _TableMeta({
    required this.id,
    required this.assetPath,
    required this.width,
    required this.height,
    required this.category,
    this.quarterTurns = 0,
    this.padding,
  });

  final String id;
  final String assetPath;
  final double width;
  final double height;
  final _TableCategory category;
  final int quarterTurns;
  final EdgeInsets? padding;
}
