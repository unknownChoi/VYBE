import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'passwallet_ticket.dart';

class PasswalletCarousel extends StatefulWidget {
  const PasswalletCarousel({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.onSelectedIndexChanged,
  });

  final List<Map<String, dynamic>> items;
  final int initialIndex;
  final ValueChanged<int>? onSelectedIndexChanged;

  @override
  State<PasswalletCarousel> createState() => _PasswalletCarouselState();
}

class _PasswalletCarouselState extends State<PasswalletCarousel> {
  late final PageController _pc;
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _pc = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 0.86,
    )..addListener(() {
        if (!mounted) return;
        setState(() {
          _page = _pc.page ?? _pc.initialPage.toDouble();
        });
      });
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.items.length;

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pc,
            itemCount: total,
            padEnds: true,
            physics: const PageScrollPhysics(),
            onPageChanged: (i) => widget.onSelectedIndexChanged?.call(i),
            itemBuilder: (context, i) {
              final diff = (_page - i).abs();
              final scale = (1 - (diff * 0.08)).clamp(0.90, 1.0);
              final elevation = (8 - diff * 6).clamp(0.0, 8.0);

              return Center(
                child: GestureDetector(
                  onTap: () {
                    _pc.animateToPage(
                      i,
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                    );
                  },
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: Container(
                      width: 345.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: elevation,
                            spreadRadius: elevation * 0.1,
                            offset: Offset(0, elevation),
                          ),
                        ],
                      ),
                      child: ticketFromMap(widget.items[i]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
