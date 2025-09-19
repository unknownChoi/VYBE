import 'package:flutter/material.dart';

class AppColors {
  // 기존
  static const Color appBackgroundColor = Color(0xFF101013);
  static const Color appPurpleColor = Color(0xFF7731FE);
  static const Color appGreenColor = Color(0xFFB5FF60);
  static const Color modelSheetColor = Color.fromRGBO(40, 40, 40, 1);

  // 추가 (near_tab_screen에서 사용하던 공용 색)
  static const Color chipBg = Color(0xFF2F2F33); // _cBgChip
  static const Color chipBorder = Color(0xFF535355); // _cChipBorder
  static const Color gray400 = Color(0xFFCACACB); // _cGray400
  static const Color gray500 = Color(0xFF9F9FA1); // _cGray500
  static const Color topBar = Color(0xFF404042); // _cTopBar
  static const Color sheet = Color.fromARGB(255, 44, 44, 49); // _cSheet
  static const Color lime500 = Color(0xFFB5FF60); // _cLime500 (= appGreenColor)
}
