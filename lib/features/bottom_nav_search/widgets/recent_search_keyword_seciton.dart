import 'package:flutter/cupertino.dart';
import 'package:vybe/features/bottom_nav_search/widgets/keyword_chip.dart';
import 'package:vybe/features/bottom_nav_search/widgets/keyword_seciton.dart';

class RecentSearchKeywordSection extends StatelessWidget {
  const RecentSearchKeywordSection({
    super.key,
    required this.recommendTitleStyle,
    required this.recommendSideStyle,
    required Future<List<String>> recentKeyword,
  }) : _recentKeyword = recentKeyword;

  final TextStyle recommendTitleStyle;
  final TextStyle recommendSideStyle;
  final Future<List<String>> _recentKeyword;

  @override
  Widget build(BuildContext context) {
    return KeywordSection(
      title: '최근 검색어',
      titleStyle: recommendTitleStyle,
      trailing: Text('전체 삭제', style: recommendSideStyle),
      future: _recentKeyword,
      emptyMessage: '최근 검색어가 없습니다.',
      chipBuilder: (keyword) => KeywordChip(isHashtag: false, keyword: keyword),
    );
  }
}
