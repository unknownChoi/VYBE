import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/widgets/near_club_card.dart';

class ClubOverviewSection extends StatefulWidget {
  const ClubOverviewSection({
    super.key,
    required this.title,
    required this.clubData,
  });

  final String title;
  final List<Map<String, dynamic>> clubData;

  @override
  State<ClubOverviewSection> createState() => _ClubOverviewSectionState();
}

class _ClubOverviewSectionState extends State<ClubOverviewSection> {
  Future<List<Map<String, String>>> _fetchNearClubs() async {
    // 외부에서 받은 clubData를 그대로 Future로 래핑
    return Future.value(
      widget.clubData
          .map(
            (e) => {
              "clubName": e["clubName"] as String,
              "clubType": e["clubType"] as String,
              "clubCity": e["clubCity"] as String,
              "clubImageSrc": e["clubImageSrc"] as String,
            },
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(widget.title, style: AppTextStyles.sectionTitle),
            const Spacer(),
            Text("전체 보기", style: AppTextStyles.seeAll),
            const SizedBox(width: 4),
            SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
          ],
        ),
        const SizedBox(height: 24),

        // ── 동적 로딩 영역
        FutureBuilder<List<Map<String, String>>>(
          future: _fetchNearClubs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return const SizedBox(
                height: 60,
                child: Center(child: Text('클럽 정보를 불러오지 못했습니다.')),
              );
            }

            final items = snapshot.data ?? const [];
            if (items.isEmpty) {
              return const SizedBox(
                height: 60,
                child: Center(child: Text('표시할 클럽이 없습니다.')),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    NearClubCard(
                      clubName: items[i]["clubName"]!,
                      clubType: items[i]["clubType"]!,
                      clubCity: items[i]["clubCity"]!,
                      clubImageSrc: items[i]["clubImageSrc"]!,
                    ),
                    if (i != items.length - 1) const SizedBox(width: 12),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
