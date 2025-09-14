// lib/utils/ui02_validators.dart

bool isInvalidBirthYearUi02(String frontText, String genderDigit) {
  if (frontText.length != 6 || genderDigit.isEmpty) return false;
  final int? yearTwoDigits = int.tryParse(frontText.substring(0, 2));
  final int? month = int.tryParse(frontText.substring(2, 4));
  final int? day = int.tryParse(frontText.substring(4, 6));
  final int? gender = int.tryParse(genderDigit);
  if (yearTwoDigits == null || gender == null || month == null || day == null)
    return false;
  int birthYear;
  if (gender == 1 || gender == 2) {
    birthYear = 1900 + yearTwoDigits;
  } else if (gender == 3 || gender == 4) {
    birthYear = 2000 + yearTwoDigits;
  } else {
    return false;
  }
  final birthDate = DateTime(birthYear, month, day);
  final now = DateTime.now();
  final adultDate = DateTime(now.year - 19, now.month, now.day);
  return birthDate.isAfter(adultDate);
}
