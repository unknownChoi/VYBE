import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 메뉴 섹션 사이를 구분하는 라인.
class MenuSectionDivider extends StatelessWidget {
  const MenuSectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1.h, thickness: 1.h, color: const Color(0xFF404042));
  }
}
