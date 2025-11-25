import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';

/// 메뉴가 없을 때 안내 문구를 보여주는 위젯.
class MenuEmptyMessage extends StatelessWidget {
  const MenuEmptyMessage({super.key, this.padding});

  /// 외부에서 전달하는 패딩 (반응형 단위 사용).
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: 24.h),
      child: Text('등록된 메뉴가 없습니다.', style: AppTextStyles.subtitle),
    );
  }
}
