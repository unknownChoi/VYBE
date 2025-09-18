import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;
  final bool isExpandedContent;
  final bool isLong;
  final VoidCallback onToggle;

  const ReviewCard({
    super.key,
    required this.review,
    required this.isExpandedContent,
    required this.isLong,
    required this.onToggle,
  });

  String _truncate(String text, {int max = 50}) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}...';
  }

  @override
  Widget build(BuildContext context) {
    final String author = review['author'];
    final String rating = review['rating'];
    final String date = review['date'];
    final String content = review['content'];
    final List<String> imageUrls =
        (review['imageUrls'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    final String displayContent =
        (!isLong || isExpandedContent) ? content : _truncate(content);

    return Container(
      constraints: BoxConstraints(minHeight: 140.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: const Color(0xFF2F2F33), width: 1.h),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Row(
            children: [
              Text(
                author,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 8.w),
              SvgPicture.asset('assets/icons/club_detail/star.svg'),
              SizedBox(width: 4.w),
              Text(
                rating,
                style: TextStyle(
                  color: const Color(0xFFECECEC),
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: TextStyle(
                  color: const Color(0xFFCACACB),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // 본문 + 이미지
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width:
                    imageUrls.isNotEmpty && imageUrls.first.isNotEmpty
                        ? 239.w
                        : 345.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayContent,
                      style: TextStyle(
                        color: const Color(0xFFECECEC),
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (isLong)
                      GestureDetector(
                        onTap: onToggle,
                        child: Row(
                          children: [
                            Text(
                              isExpandedContent ? '접기' : '자세히 보기',
                              style: const TextStyle(
                                color: Color(0xFF9F9FA1),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            SvgPicture.asset(
                              width: 8.w,
                              isExpandedContent
                                  ? 'assets/icons/club_detail/arrow_up.svg'
                                  : 'assets/icons/club_detail/arrow_down.svg',
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),
              if (imageUrls.isNotEmpty && imageUrls.first.isNotEmpty)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      imageUrls.first,
                      width: 90.w,
                      height: 90.h,
                      fit: BoxFit.cover,
                    ),
                    if (imageUrls.length > 1)
                      Positioned(
                        bottom: 6.h,
                        right: 6.w,
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: const BoxDecoration(
                            color: Color(0xCC191919),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${imageUrls.length - 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
