import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/club_detail_page/widgets/atoms/custom_divider.dart';
import 'package:vybe/features/club_detail_page/widgets/call_button.dart';
import 'package:vybe/features/club_detail_page/widgets/tag.dart';

class ClubHeader extends StatefulWidget {
  const ClubHeader({super.key});

  @override
  State<ClubHeader> createState() => _ClubHeaderState();
}

class _ClubHeaderState extends State<ClubHeader> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                items:
                    (clubData['coverImage'] as List<String>)
                        .map(
                          (item) => Image.asset(
                            item,
                            width: double.infinity,
                            height: 186.h,
                            fit: BoxFit.cover,
                          ),
                        )
                        .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  height: 186.h,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() => currentIndex = index);
                  },
                ),
              ),
              Positioned(
                left: 12.w,
                top: 50.h,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                right: 12.w,
                top: 45.h,
                child: SvgPicture.asset('assets/icons/club_detail/share.svg'),
              ),
              Positioned(
                right: 50.w,
                top: 50.h,
                child: SvgPicture.asset('assets/icons/club_detail/heart.svg'),
              ),
              Positioned(
                right: 12.w,
                bottom: 12.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 9.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC191919),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${(clubData["coverImage"] as List).length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  clubData['category']! as String,
                  style: AppTextStyles.subtitle,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      clubData['name']! as String,
                      style: AppTextStyles.title,
                    ),
                    const Spacer(),
                    const CallButton(),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children:
                      (clubData['tags'] as List<String>)
                          .map(
                            (tag) => Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Tag(text: tag),
                            ),
                          )
                          .toList(),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/club_detail/star.svg',
                      width: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      clubData['rating']! as String,
                      style: AppTextStyles.body,
                    ),
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      'assets/icons/club_detail/dot.svg',
                      width: 4.w,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "리뷰 ${clubData['reviews']! as String}",
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  clubData['description']! as String,
                  style: AppTextStyles.subtitle.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
              ],
            ),
          ),
          const CustomDivider(),
        ],
      ),
    );
  }
}
