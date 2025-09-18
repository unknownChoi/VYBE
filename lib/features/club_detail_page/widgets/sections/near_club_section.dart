import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/widgets/near_club_card.dart';

class NearClubSection extends StatelessWidget {
  const NearClubSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("주변 클럽", style: AppTextStyles.sectionTitle),
            const Spacer(),
            Text("전체 보기", style: AppTextStyles.seeAll),
            const SizedBox(width: 4),
            SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
          ],
        ),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: const Row(
            children: [
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_1.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_2.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_3.png",
              ),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_1.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_2.png",
              ),
              SizedBox(width: 12),
              NearClubCard(
                clubName: "클럽 레이저",
                clubType: "힙합",
                clubCity: "홍대",
                clubImageSrc: "assets/images/test_image/test_3.png",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
