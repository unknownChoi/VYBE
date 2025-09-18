import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/club_detail_mock_data.dart';

import 'custom_divider.dart';
import 'club_overview_section.dart';
import 'club_signature_section.dart';
import 'club_image_area.dart';
import 'near_club_section.dart';

class HomeTab extends StatelessWidget {
  final TabController tabController;
  final ScrollController scrollController;
  final VoidCallback onSeeAllMenu;
  final VoidCallback onSeeAllPhoto;

  const HomeTab({
    required this.tabController,
    required this.scrollController,
    required this.onSeeAllMenu,
    required this.onSeeAllPhoto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubOverviewSection(clubData: clubData),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubSignatureSection(onSeeAll: onSeeAllMenu),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: ClubImageArea(
              images: clubData['images']! as List<String>,
              onSeeAll: onSeeAllPhoto,
            ),
          ),
          const CustomDivider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: const NearClubSection(),
          ),
          SizedBox(height: 118.h),
        ],
      ),
    );
  }
}
