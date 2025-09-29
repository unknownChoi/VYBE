import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PillSegmentedNav extends StatefulWidget {
  const PillSegmentedNav({
    super.key,
    required this.items,
    this.initialIndex = 0,
    required this.onChanged,
    this.height = 36,
    this.trackColor = const Color(0xFF2E2F33),
    this.indicatorColor = const Color(0xFF525357),
    this.textStyle,
    this.unselectedOpacity = .65,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
  });

  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final Color trackColor;
  final Color indicatorColor;
  final TextStyle? textStyle;
  final double unselectedOpacity;
  final BorderRadius borderRadius;

  @override
  State<PillSegmentedNav> createState() => _PillSegmentedNavState();
}

class _PillSegmentedNavState extends State<PillSegmentedNav> {
  late int _index = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalW = constraints.maxWidth;
        final innerW = totalW;
        final itemW = innerW / widget.items.length;

        final baseStyle = widget.textStyle ??
            TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600);

        return Container(
          height: widget.height.h,
          decoration: BoxDecoration(
            color: widget.trackColor,
            borderRadius: widget.borderRadius,
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                left: itemW * _index,
                top: 0,
                bottom: 0,
                width: itemW,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.indicatorColor,
                    borderRadius: widget.borderRadius,
                  ),
                ),
              ),
              Row(
                children: List.generate(widget.items.length, (i) {
                  final selected = i == _index;
                  return Expanded(
                    child: InkWell(
                      borderRadius: widget.borderRadius,
                      onTap: () {
                        if (_index == i) return;
                        setState(() => _index = i);
                        widget.onChanged(i);
                      },
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          style: baseStyle.copyWith(
                            color: Colors.white.withOpacity(
                              selected ? 1.0 : widget.unselectedOpacity,
                            ),
                          ),
                          child: Text(
                            widget.items[i],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.14.h,
                              letterSpacing: (-0.35).w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
