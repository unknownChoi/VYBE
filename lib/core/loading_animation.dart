import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:vybe/core/app_colors.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  final List<Color> _colors = [
    AppColors.appPurpleColor,
    AppColors.appGreenColor,
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: _colors[0],
      end: _colors[1],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 웨이브 주기 완료 시 색상 순환
        if (_controller.status == AnimationStatus.completed) {
          _colors.add(_colors.removeAt(0));
        }

        return SpinKitWave(
          color: _colorAnimation.value,
          size: 50.0,
          duration: const Duration(milliseconds: 1400),
        );
      },
    );
  }
}
