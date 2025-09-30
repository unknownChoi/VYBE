// 한글 검색 유틸: 초성/종성 무시 매칭
const int _BASE = 0xAC00, _END = 0xD7A3;
const _CHO = [
  'ㄱ',
  'ㄲ',
  'ㄴ',
  'ㄷ',
  'ㄸ',
  'ㄹ',
  'ㅁ',
  'ㅂ',
  'ㅃ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅉ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ',
];
const _JUNG = [
  'ㅏ',
  'ㅐ',
  'ㅑ',
  'ㅒ',
  'ㅓ',
  'ㅔ',
  'ㅕ',
  'ㅖ',
  'ㅗ',
  'ㅘ',
  'ㅙ',
  'ㅚ',
  'ㅛ',
  'ㅜ',
  'ㅝ',
  'ㅞ',
  'ㅟ',
  'ㅠ',
  'ㅡ',
  'ㅢ',
  'ㅣ',
];
const _JONG = [
  '',
  'ㄱ',
  'ㄲ',
  'ㄳ',
  'ㄴ',
  'ㄵ',
  'ㄶ',
  'ㄷ',
  'ㄹ',
  'ㄺ',
  'ㄻ',
  'ㄼ',
  'ㄽ',
  'ㄾ',
  'ㄿ',
  'ㅀ',
  'ㅁ',
  'ㅂ',
  'ㅄ',
  'ㅅ',
  'ㅆ',
  'ㅇ',
  'ㅈ',
  'ㅊ',
  'ㅋ',
  'ㅌ',
  'ㅍ',
  'ㅎ',
];

({String cho, String jung, String jong}) _split(String ch) {
  final code = ch.codeUnitAt(0);
  if (code < _BASE || code > _END) return (cho: ch, jung: '', jong: '');
  final idx = code - _BASE;
  final ci = idx ~/ (21 * 28);
  final ji = (idx % (21 * 28)) ~/ 28;
  final ki = idx % 28;
  return (cho: _CHO[ci], jung: _JUNG[ji], jong: _JONG[ki]);
}

String toChoseong(String s) {
  final b = StringBuffer();
  for (final r in s.runes) b.write(_split(String.fromCharCode(r)).cho);
  return b.toString();
}

String toChoJung(String s) {
  final b = StringBuffer();
  for (final r in s.runes) {
    final sp = _split(String.fromCharCode(r));
    b.write(sp.cho + sp.jung); // 종성 제거
  }
  return b.toString();
}

String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'\s+'), '');

/// 한글 친화 매칭: 일반 포함 || 초성 포함 || 종성무시 포함
bool koMatch(String source, String query) {
  final s = _norm(source);
  final q = _norm(query);
  if (q.isEmpty) return true;
  if (s.contains(q)) return true;
  if (toChoseong(s).contains(toChoseong(q))) return true;
  if (toChoJung(s).contains(toChoJung(q))) return true;
  return false;
}
