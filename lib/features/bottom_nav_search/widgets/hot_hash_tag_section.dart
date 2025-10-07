import 'package:flutter/cupertino.dart';
import 'package:vybe/features/bottom_nav_search/widgets/keyword_chip.dart';
import 'package:vybe/features/bottom_nav_search/widgets/keyword_seciton.dart';

class HotHashTagSection extends StatelessWidget {
  const HotHashTagSection({
    super.key,
    required this.recommendTitleStyle,
    required Future<List<String>> hotHashTags,
  }) : _hotHashTags = hotHashTags;

  final TextStyle recommendTitleStyle;
  final Future<List<String>> _hotHashTags;

  @override
  Widget build(BuildContext context) {
    return KeywordSection(
      title: '인기 해시태그 추천',
      titleStyle: recommendTitleStyle,
      future: _hotHashTags,
      emptyMessage: '인기 해시태그가 없습니다.',
      chipBuilder: (keyword) => KeywordChip(isHashtag: true, keyword: keyword),
    );
  }
}
