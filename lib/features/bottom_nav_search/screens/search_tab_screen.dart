import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/utils/korean_search.dart'; // koMatch 사용

import 'package:vybe/core/widgets/near_club_section.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/bottom_nav_search/widgets/hot_hash_tag_section.dart';
import 'package:vybe/features/bottom_nav_search/widgets/recent_search_keyword_seciton.dart';
import 'package:vybe/features/bottom_nav_search/widgets/search_section.dart';
import 'package:vybe/features/main_bottom_nav/widgets/main_tab_config.dart';

class SearchTabScreen extends StatefulWidget {
  const SearchTabScreen({super.key});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  late Future<List<String>> _recentKeyword;
  late Future<List<String>> _hotHashTags;

  String _query = '';

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

  /// 연관 검색 후보 (예시)
  final List<String> _candidates = const [
    '홍대',
    '호계역 클럽',
    '호서역',
    '합정',
    '홍제',
    '호국로',
    '건대입구',
    '을지로',
    '이태원',
    '강남',
  ];

  /// koMatch(초성/종성무시) 기반 필터
  List<String> _suggest(String q) {
    if (q.trim().isEmpty) return const [];
    return _candidates.where((k) => koMatch(k, q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bool hasQuery = _query.trim().isNotEmpty;
    final suggestions = _suggest(_query);

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, bottomInset + 16.h),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchSection(
              onChanged: (q) => setState(() => _query = q),
              onSubmitted: (q) => setState(() => _query = q),
            ),
            SizedBox(height: hasQuery ? 12.h : 24.h),

            if (hasQuery) ...[
              // 연관 검색어 카드 리스트
              ...suggestions.map(
                (s) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: SuggestionCard(
                    suggestion: s,
                    query: _query,
                    onTap: () {
                      // 탭 시 원하는 동작(검색 실행/페이지 이동 등)
                      setState(() => _query = s);
                    },
                  ),
                ),
              ),
              if (suggestions.isEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    '연관 검색어가 없습니다.',
                    style: TextStyle(
                      color: const Color(0xFF9F9FA1),
                      fontSize: 14.sp,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
            ] else ...[
              // 검색어 비어있을 때 기존 섹션
              RecentSearchKeywordSection(
                recommendTitleStyle: recommendTitleStyle,
                recommendSideStyle: recommendSideStyle,
                recentKeyword: _recentKeyword,
              ),
              SizedBox(height: 44.h),
              HotHashTagSection(
                recommendTitleStyle: recommendTitleStyle,
                hotHashTags: _hotHashTags,
              ),
              SizedBox(height: 44.h),
              ClubOverviewSection(title: "핫한클럽", clubData: searchClubData),
            ],
          ],
        ),
      ),
    );
  }
}

/// 연관 검색어 카드 위젯
class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
    required this.suggestion,
    required this.query,
    this.onTap,
  });

  final String suggestion;
  final String query;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: Colors.transparent, // 필요 시 배경색/보더 추가
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: _buildHighlightedText(suggestion, query),
      ),
    );
  }

  /// 입력한 내용과 '직접 겹치는 부분'을 초록색으로 하이라이트
  /// (koMatch는 초성/종성무시 필터링용, 시각 하이라이트는 일반 포함 기준)
  Widget _buildHighlightedText(String text, String q) {
    final baseStyle = TextStyle(
      color: const Color(0xFFECECEC) /* Gray200 */,
      fontSize: 17.sp,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w400,
      height: 1.29,
      letterSpacing: -(0.2).w,
    );

    final highlightStyle = baseStyle.copyWith(
      color: const Color(0xFF94CF51) /* Main-Lime700 */,
    );

    final queryTrim = q.trim();
    if (queryTrim.isEmpty) {
      return Text(text, style: baseStyle, textAlign: TextAlign.start);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = queryTrim.toLowerCase();

    // 모든 매치 구간 수집
    final matches = <_SpanRange>[];
    int start = 0;
    while (true) {
      final idx = lowerText.indexOf(lowerQuery, start);
      if (idx == -1) break;
      matches.add(_SpanRange(idx, idx + lowerQuery.length));
      start = idx + lowerQuery.length;
    }

    if (matches.isEmpty) {
      // (옵션) 초성/종성무시 하이라이트까지 원하면 여기에 추가 로직 구현
      return Text(text, style: baseStyle, textAlign: TextAlign.start);
    }

    // 하이라이트된 RichText 구성
    final spans = <TextSpan>[];
    int cursor = 0;
    for (final m in matches) {
      if (cursor < m.start) {
        spans.add(
          TextSpan(text: text.substring(cursor, m.start), style: baseStyle),
        );
      }
      spans.add(
        TextSpan(text: text.substring(m.start, m.end), style: highlightStyle),
      );
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor), style: baseStyle));
    }

    return Text.rich(TextSpan(children: spans), textAlign: TextAlign.start);
  }
}

class _SpanRange {
  final int start;
  final int end;
  const _SpanRange(this.start, this.end);
}
