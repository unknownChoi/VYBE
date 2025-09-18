import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';

class ClubImageArea extends StatelessWidget {
  final List<String> images;
  final VoidCallback? onSeeAll;
  const ClubImageArea({super.key, required this.images, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("사진", style: AppTextStyles.sectionTitle),
            SizedBox(width: 8.w),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('전체보기', style: AppTextStyles.seeAll),
                  SizedBox(width: 4.w),
                  SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final imagePath in images)
                Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      imagePath,
                      width: 165.w,
                      height: 110.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
