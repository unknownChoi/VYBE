import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_text_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    required this.title,
    this.showSeeAll = true,
    this.onSeeAllTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.sectionTitle),
        if (showSeeAll) ...[
          const Spacer(),
          GestureDetector(
            onTap: onSeeAllTap ?? () {},
            child: Row(
              children: [
                Text("전체보기", style: AppTextStyles.seeAll),
                const SizedBox(width: 4),
                SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
