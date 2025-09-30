import 'dart:async'; // Timer, Future, Stream 등
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key, this.onChanged, this.onSubmitted});

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleChanged(String v) {
    // 필요 시 디바운스 (동일 디자인 유지, 동작만 개선)
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      widget.onChanged?.call(v);
    });
  }

  void _handleSubmitted(String v) {
    widget.onSubmitted?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: const Color(0XFFECECEC),
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                height: 42.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF404042),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: _handleChanged,
                        onSubmitted: _handleSubmitted,
                        textInputAction: TextInputAction.search,
                        cursorColor: const Color(0xFFECECEC),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.14,
                          letterSpacing: -(0.70).w,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: '검색 (예: 홍대, EDM, ㅎㄷ)',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.14,
                            letterSpacing: -(0.70).w,
                          ),
                          // 컨테이너 패딩과 겹치지 않도록 내부 패딩 최소화
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    // ▶ 오른쪽 검색 아이콘 (위치/크기/색 동일)
                    SvgPicture.asset(
                      'assets/icons/common/search.svg',
                      width: 18.w,
                      color: const Color(0XFF9F9FA1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
