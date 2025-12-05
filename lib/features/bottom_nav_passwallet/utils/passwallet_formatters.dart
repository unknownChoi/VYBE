/// 2025-10-03M → 10월 03일 금요일
String formatKoreanDate(String raw) {
  final weekdayCode = RegExp(r'[A-Z]$').hasMatch(raw)
      ? raw.substring(raw.length - 1)
      : null;
  final datePart = weekdayCode == null ? raw : raw.substring(0, raw.length - 1);

  DateTime? dt;
  try {
    final parts = datePart.split('-');
    if (parts.length == 3) {
      dt = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }
  } catch (_) {}

  final weekdayKo = dt == null
      ? _weekdayFromCode(weekdayCode)
      : _weekdayKoFromDateTime(dt);

  if (dt == null) return raw;
  final mm = dt.month.toString().padLeft(2, '0');
  final dd = dt.day.toString().padLeft(2, '0');
  return '$mm월 $dd일 $weekdayKo';
}

String _weekdayFromCode(String? code) {
  switch (code) {
    case 'M':
      return '월요일';
    case 'T':
      return '화요일';
    case 'W':
      return '수요일';
    case 'R':
      return '목요일';
    case 'F':
      return '금요일';
    case 'S':
      return '토요일';
    case 'U':
      return '일요일';
    default:
      return '';
  }
}

String _weekdayKoFromDateTime(DateTime dt) {
  const yoil = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
  return yoil[dt.weekday - 1];
}

/// 21:25 → 오후 9:25
String formatAmPm(String hhmm) {
  try {
    final parts = hhmm.split(':');
    final h = int.parse(parts[0]);
    final m = parts[1].padLeft(2, '0');
    final isPm = h >= 12;
    final h12 = ((h + 11) % 12) + 1;
    return '${isPm ? '오후' : '오전'} $h12:$m';
  } catch (_) {
    return hhmm;
  }
}

/// target - today in days. D0은 오늘, 양수는 D-n, 음수는 지난 날짜.
int? calcDDay(String raw) {
  final code = RegExp(r'[A-Z]$').hasMatch(raw)
      ? raw.substring(raw.length - 1)
      : null;
  final datePart = code == null ? raw : raw.substring(0, raw.length - 1);

  try {
    final parts = datePart.split('-');
    if (parts.length != 3) return null;
    final target = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    final today = DateTime.now();
    final t0 = DateTime(today.year, today.month, today.day);
    final t1 = DateTime(target.year, target.month, target.day);
    return t1.difference(t0).inDays;
  } catch (_) {
    return null;
  }
}
