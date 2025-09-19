import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

/// Naver Map SDK 초기화 유틸 (한 번만 초기화)
class NaverMapService {
  static bool _initialized = false;
  static final Completer<void> _completer = Completer<void>();

  /// 앱 시작 시 한 번 호출하세요.
  static Future<void> init() async {
    if (_initialized) return _completer.future;

    try {
      await FlutterNaverMap().init(
        clientId: '6jetyz32jo',
        onAuthFailed: (ex) {
          switch (ex) {
            case NQuotaExceededException(:final message):
              debugPrint('사용량 초과 (message: $message)');
            case NUnauthorizedClientException():
            case NClientUnspecifiedException():
            case NAnotherAuthFailedException():
              debugPrint('인증 실패: $ex');
          }
        },
      );

      _initialized = true;
      if (!_completer.isCompleted) _completer.complete();
    } catch (e, s) {
      if (!_completer.isCompleted) _completer.completeError(e, s);
      rethrow;
    }

    return _completer.future;
  }
}
