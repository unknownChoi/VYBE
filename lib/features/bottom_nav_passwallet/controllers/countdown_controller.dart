import 'dart:async';
import 'package:flutter/foundation.dart';

class CountdownController {
  CountdownController({required this.qrInitial, required this.entryInitial});

  final Duration qrInitial; // ex) const Duration(seconds: 60)
  final Duration entryInitial; // ex) const Duration(minutes: 15)

  final ValueNotifier<Duration> qrLeft = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> entryLeft = ValueNotifier(Duration.zero);

  Timer? _qrT;
  Timer? _entryT;

  void startForEntering() {
    stop();
    qrLeft.value = qrInitial;
    entryLeft.value = entryInitial;

    _qrT = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = qrLeft.value - const Duration(seconds: 1);
      qrLeft.value = next.isNegative ? Duration.zero : next;
      if (qrLeft.value == Duration.zero) _qrT?.cancel();
    });

    _entryT = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = entryLeft.value - const Duration(seconds: 1);
      entryLeft.value = next.isNegative ? Duration.zero : next;
      if (entryLeft.value == Duration.zero) _entryT?.cancel();
    });
  }

  void resetQr() {
    _qrT?.cancel();
    qrLeft.value = qrInitial;
    _qrT = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = qrLeft.value - const Duration(seconds: 1);
      qrLeft.value = next.isNegative ? Duration.zero : next;
      if (qrLeft.value == Duration.zero) _qrT?.cancel();
    });
  }

  void stop() {
    _qrT?.cancel();
    _entryT?.cancel();
  }

  void dispose() {
    stop();
    qrLeft.dispose();
    entryLeft.dispose();
  }
}
