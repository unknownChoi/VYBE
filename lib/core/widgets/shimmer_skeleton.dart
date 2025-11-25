import 'package:flutter/material.dart';

class ShimmerSkeleton extends StatefulWidget {
  const ShimmerSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerSkeleton> createState() => _ShimmerSkeletonState();
}

class _ShimmerSkeletonState extends State<ShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (rect) {
              const base = Color(0xFF4A4A50); // 회색 배경
              const highlight = Color(0xFFBEBEC0); // 밝은 회색 하이라이트
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [base, highlight, base],
                stops: const [0.05, 0.35, 0.65],
                transform: const GradientRotation(0.785398), // 45도
                tileMode: TileMode.clamp,
              ).createShader(rect.shift(
                Offset(_animation.value * rect.width, 0),
              ));
            },
            child: Container(
              width: widget.width,
              height: widget.height,
              color: const Color(0xFF4A4A50),
            ),
          );
        },
      ),
    );
  }
}
