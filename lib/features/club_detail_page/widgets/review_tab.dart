import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/club_detail_page/widgets/revuew_card.dart';

class ReviewTab extends StatefulWidget {
  const ReviewTab({super.key});

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  bool _isExpanded = false;
  final Set<int> _expandedContent = <int>{};

  @override
  Widget build(BuildContext context) {
    final reviewsToShow =
        _isExpanded ? reviewsData : reviewsData.take(5).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            itemCount: reviewsToShow.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final review = reviewsToShow[index];
              final String content = review['content'];
              final bool isLong = content.length > 70;
              final bool isContentExpanded = _expandedContent.contains(index);

              return ReviewCard(
                review: review,
                isExpandedContent: isContentExpanded,
                isLong: isLong,
                onToggle: () {
                  setState(() {
                    if (isContentExpanded) {
                      _expandedContent.remove(index);
                    } else {
                      _expandedContent.add(index);
                    }
                  });
                },
              );
            },
          ),
          if (reviewsData.length > 5 && !_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: GestureDetector(
                onTap: () => setState(() => _isExpanded = true),
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF404042)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text('리뷰 더보기 (${reviewsData.length - 5}개)'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
