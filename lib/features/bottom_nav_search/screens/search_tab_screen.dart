import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/main_bottom_nav/widgets/main_tab_config.dart';

class SearchTabScreen extends StatefulWidget {
  const SearchTabScreen({super.key});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  late Future<List<String>> _recentKeyword;
  late Future<List<String>> _hotHashTags;

  Future<List<String>> fetchRecentKeywords() async {
    await Future.delayed(const Duration(milliseconds: 400)); // 모의 지연
    return userRecentSearchKeyword;
  }

  Future<List<String>> fetchHotHasgTags() async {
    await Future.delayed(const Duration(milliseconds: 400)); // 모의 지연
    return hotHashTags;
  }

  final TextStyle recommendTitleStyle = TextStyle(
    color: const Color(0xFFECECEC) /* Gray200 */,
    fontSize: 20.sp,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    height: 1.10,
    letterSpacing: -(0.50).w,
  );

  final TextStyle recommendSideStyle = TextStyle(
    color: const Color(0xFFECECEC) /* Gray200 */,
    fontSize: 12.sp,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w400,
    height: 1.17,
    letterSpacing: -(0.30).w,
  );

  @override
  void initState() {
    super.initState();
    _recentKeyword = fetchRecentKeywords(); // 최초 1회 로드
    _hotHashTags = fetchHotHasgTags();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SearchSection(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('최근 검색어', style: recommendTitleStyle),
                          Spacer(),
                          Text('전체 삭제', style: recommendSideStyle),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      // (2) Wrap 자리에 FutureBuilder 넣기
                      FutureBuilder<List<String>>(
                        future: _recentKeyword,
                        builder: (context, snap) {
                          // 로딩 상태: 스켈레톤 칩 6개
                          if (snap.connectionState != ConnectionState.done) {
                            return SizedBox(
                              width: double.infinity,

                              child: Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children: List.generate(6, (_) {
                                  return Container(
                                    height: 24.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2F2F33),
                                      borderRadius: BorderRadius.circular(
                                        999.r,
                                      ),
                                    ),
                                    width: 88.w,
                                  );
                                }),
                              ),
                            );
                          }

                          if (snap.hasError) {
                            return Text(
                              '불러오기에 실패했습니다.',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.sp,
                              ),
                            );
                          }

                          final data = snap.data ?? const <String>[];
                          if (data.isEmpty) {
                            return Text(
                              '최근 검색어가 없습니다.',
                              style: TextStyle(
                                color: const Color(0xFFCACACB),
                                fontSize: 14.sp,
                              ),
                            );
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: data
                                  .map(
                                    (k) => RecenetSearchKeywordCard(
                                      isHashtag: false,
                                      keyword: k,
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 44.h),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('인기 해시태그 추천', style: recommendTitleStyle),
                            SizedBox(height: 24.h),
                            FutureBuilder<List<String>>(
                              future: _hotHashTags,
                              builder: (context, snap) {
                                // 로딩 상태: 스켈레톤 칩 6개
                                if (snap.connectionState !=
                                    ConnectionState.done) {
                                  return SizedBox(
                                    width: double.infinity,

                                    child: Wrap(
                                      spacing: 8.w,
                                      runSpacing: 8.h,
                                      children: List.generate(6, (_) {
                                        return Container(
                                          height: 24.h,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 5.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2F2F33),
                                            borderRadius: BorderRadius.circular(
                                              999.r,
                                            ),
                                          ),
                                          width: 88.w,
                                        );
                                      }),
                                    ),
                                  );
                                }

                                if (snap.hasError) {
                                  return Text(
                                    '불러오기에 실패했습니다.',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14.sp,
                                    ),
                                  );
                                }

                                final data = snap.data ?? const <String>[];
                                if (data.isEmpty) {
                                  return Text(
                                    '최근 검색어가 없습니다.',
                                    style: TextStyle(
                                      color: const Color(0xFFCACACB),
                                      fontSize: 14.sp,
                                    ),
                                  );
                                }

                                return SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    children: data
                                        .map(
                                          (k) => RecenetSearchKeywordCard(
                                            isHashtag: true,
                                            keyword: k,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecenetSearchKeywordCard extends StatelessWidget {
  const RecenetSearchKeywordCard({
    super.key,
    required this.keyword,
    required this.isHashtag,
  });

  final String keyword;
  final bool isHashtag;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isHashtag) ...[
            Text(
              keyword,
              style: TextStyle(
                color: const Color(0xFFCACACB) /* Gray400 */,
                fontSize: 14.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.14,
                letterSpacing: -(0.70).w,
              ),
            ),
            SizedBox(width: 8.w),
            SvgPicture.asset(width: 8.w, 'assets/icons/search_tab/x_mark.svg'),
          ] else ...[
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '# ',
                    style: TextStyle(
                      color: const Color(0xFF94CF51) /* Main-Lime700 */,
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.14,
                      letterSpacing: -0.70,
                    ),
                  ),
                  TextSpan(
                    text: keyword,
                    style: TextStyle(
                      color: const Color(0xFFCACACB) /* Gray400 */,
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.14,
                      letterSpacing: -0.70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                color: Color(0XFFECECEC),
                size: 24.sp,
                Icons.arrow_back_ios,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Container(
                height: 42.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Color(0xFF404042),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Row(
                  children: [
                    Spacer(),
                    SvgPicture.asset(
                      width: 18.w,
                      color: Color(0XFF9F9FA1),
                      'assets/icons/common/search.svg',
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
