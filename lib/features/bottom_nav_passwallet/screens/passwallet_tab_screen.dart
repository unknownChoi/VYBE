import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';

class PasswalletTabScreen extends StatelessWidget {
  const PasswalletTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double kHoleRadius = 6;

    return Column(
      children: [
        SizedBox(height: 22.h),
        SafeArea(
          child: Center(
            child: SizedBox(
              width: 345.w,
              height: 36.h,
              child: PillSegmentedNav(
                items: ["입장권", "예약", "이용 안내"],
                onChanged: (i) {
                  print("good");
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Divider(height: 1.h, thickness: 1.h, color: Color(0xFF2F2F33)),
        SizedBox(height: 36.h),
        Container(
          width: 345.w,
          height: 98.h,
          decoration: BoxDecoration(
            color: AppColors.appPurpleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
        ),
        Container(
          width: 345.w,
          height: 200.h,
          decoration: BoxDecoration(color: Color(0Xff2f2f33)),
        ),
        SizedBox(height: 4.h),
        Stack(
          clipBehavior: Clip.none,
          children: [
            // 배경(사용자 지정 child)
            Container(
              width: 345.w,
              height: 200.h,
              decoration: const BoxDecoration(color: Color(0xFF2F2F33)),
            ),

            // 중앙 텍스트

            // 하단 천공(퍼포레이션) - 배경 투명처리 레이어 제외
            Positioned(
              left: 0,
              right: 0,
              bottom: -kHoleRadius + (-5.h),
              height: 14.h,
              child: const _Perforation(), // 별도 정의 필요
            ),
          ],
        ),
      ],
    );
  }
}

/// 하단 퍼포레이션(톱니)만 구현한 위젯
// 투명 처리(BlendMode.clear) 제거 + "원 개수"로 배치하는 버전

class _Perforation extends StatelessWidget {
  const _Perforation({
    this.holeRadius = 12.0,
    this.count = 12, // 그릴 원의 개수
    this.edgePadding = 8.0, // 좌우 여백
    this.color, // 점 색 (미지정 시 앱 배경색)
  });

  final double holeRadius;
  final int count;
  final double edgePadding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PerforationPainter(
        holeRadius: holeRadius,
        count: count,
        edgePadding: edgePadding,
        color: color ?? AppColors.appBackgroundColor,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _PerforationPainter extends CustomPainter {
  _PerforationPainter({
    required this.holeRadius,
    required this.count,
    required this.edgePadding,
    required this.color,
  });

  final double holeRadius;
  final int count;
  final double edgePadding;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final paint = Paint()..color = color;

    // 안전 처리: count가 1 이하이면 가운데 하나만 그린다.
    if (count <= 1) {
      canvas.drawCircle(Offset(size.width / 2, cy), holeRadius, paint);
      return;
    }

    final usableW = (size.width - edgePadding * 2).clamp(0.0, double.infinity);
    final step = usableW / (count - 1);

    for (int i = 0; i < count; i++) {
      final x = edgePadding + step * i;
      canvas.drawCircle(Offset(x, cy), holeRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PerforationPainter old) =>
      old.holeRadius != holeRadius ||
      old.count != count ||
      old.edgePadding != edgePadding ||
      old.color != color;
}

class PillSegmentedNav extends StatefulWidget {
  const PillSegmentedNav({
    super.key,
    required this.items,
    this.initialIndex = 0,
    required this.onChanged,
    this.height = 36,
    this.trackColor = const Color(0xFF2E2F33), // 바탕(트랙)
    this.indicatorColor = const Color(0xFF525357), // 선택 인디케이터
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    this.unselectedOpacity = .65,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
  });

  final List<String> items;
  final int initialIndex;
  final ValueChanged<int> onChanged;
  final double height;
  final Color trackColor;
  final Color indicatorColor;
  final TextStyle textStyle;
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
      builder: (context, c) {
        final totalW = c.maxWidth;
        final innerW = totalW;
        final itemW = innerW / widget.items.length;

        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.trackColor,
            borderRadius: widget.borderRadius,
          ),
          child: Stack(
            children: [
              // 선택 인디케이터
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

              // 탭들
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
                          style: widget.textStyle.copyWith(
                            color: Colors.white.withOpacity(
                              selected ? 1.0 : widget.unselectedOpacity,
                            ),
                          ),
                          child: Text(
                            widget.items[i],
                            style: TextStyle(
                              color: Colors.white /* White */,
                              fontSize: 14.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 1.14.h,
                              letterSpacing: -0.35.w,
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
