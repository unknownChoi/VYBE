import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPageTabScreen extends StatelessWidget {
  const MyPageTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "내 정보 페이지",
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }
}
