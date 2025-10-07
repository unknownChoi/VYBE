import '../models/passwallet_models.dart';

extension PassStatusX on PassStatus {
  String get label => switch (this) {
    PassStatus.waiting => '입장 대기 중',
    PassStatus.entering => '입장 중',
    PassStatus.entered => '입장완료',
    PassStatus.reservation => '예약완료',
  };

  /// QR 표시 조건(지금 로직 유지: waiting/예약은 오버레이)
  bool get showsQr => this != PassStatus.waiting;
}
