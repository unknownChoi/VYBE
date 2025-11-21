import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 예약 입력 섹션에서 사용되는 공용 아코디언 타일.
class BookingTile extends StatefulWidget {
  const BookingTile({
    super.key,
    required this.title,
    this.child,
    this.leadingAsset,
    this.trailingArrow = false,
    this.onTap,
    this.onExpansionChanged,
  });

  final String title;
  final Widget? child;
  final String? leadingAsset;
  final bool trailingArrow;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  State<BookingTile> createState() => _BookingTileState();
}

class _BookingTileState extends State<BookingTile> {
  final GlobalKey _expansionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final bool handleTap = widget.onTap != null;
    final List<Widget> children = handleTap || widget.child == null
        ? const []
        : [SizedBox(width: double.infinity, child: widget.child)];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFF2F2F33), width: 1.w),
        ),
      ),
      constraints: BoxConstraints(minHeight: 64.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          key: _expansionKey,
          tilePadding: EdgeInsets.zero,
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          leading: widget.leadingAsset != null
              ? SvgPicture.asset(widget.leadingAsset!, width: 24.w, height: 24.w)
              : null,
          childrenPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
          collapsedShape: const RoundedRectangleBorder(side: BorderSide(color: Colors.transparent)),
          title: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          trailing: widget.trailingArrow
              ? const Icon(Icons.chevron_right_rounded, color: Colors.white)
              : null,
          onExpansionChanged: (expanded) {
            widget.onExpansionChanged?.call(expanded);
            if (handleTap && expanded) {
              widget.onTap?.call();
              Future.microtask(() {
                final state = _expansionKey.currentState;
                if (state != null) {
                  (state as dynamic).collapse();
                }
              });
            }
          },
          children: children,
        ),
      ),
    );
  }
}

