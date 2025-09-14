import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswalletTabScreen extends StatelessWidget {
  const PasswalletTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "패스월렛 페이지",
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }
}
