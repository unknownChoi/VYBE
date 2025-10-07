import 'dart:ui';
import 'package:flutter/material.dart';

Future<T?> showScaleBlurDialog<T>(BuildContext context, Widget child) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'dialog',
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, __, ___) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6 * anim.value,
          sigmaY: 6 * anim.value,
        ),
        child: Opacity(
          opacity: anim.value,
          child: Transform.scale(
            scale: 0.97 + 0.03 * curved.value,
            child: Center(child: child),
          ),
        ),
      );
    },
  );
}
