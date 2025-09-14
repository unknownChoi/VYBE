import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTabScreen extends StatelessWidget {
  const SearchTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "검색 페이지",
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }
}
