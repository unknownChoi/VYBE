import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class KeywordChip extends StatelessWidget {
  const KeywordChip({
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
        color: const Color(0xFF2F2F33),
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
