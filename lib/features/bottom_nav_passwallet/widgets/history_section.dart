import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';
import 'package:vybe/features/bottom_nav_passwallet/utils/passwallet_formatters.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/club_cards/history_club_card.dart';

class HistorySection extends StatefulWidget {
  const HistorySection({super.key});

  @override
  State<HistorySection> createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  late final Future<List<Map<String, dynamic>>> _future;

  Future<List<Map<String, dynamic>>> fetchHistoryData() async {
    return passwalletHistoryData;
  }

  @override
  void initState() {
    super.initState();
    _future = fetchHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: items.length * 2,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index.isOdd) {
              return Divider(
                height: 1.h,
                thickness: 1.h,
                color: const Color(0xFF2F2F33),
              );
            }

            final i = index ~/ 2;
            final m = items[i];

            final HistoryClubCardReviewStatus status =
                m['reviewStatus'] as HistoryClubCardReviewStatus;
            final String clubName = m['clubName'] as String;
            final String rawDate = m['scheduledDate'] as String;
            final String formattedDate = formatKoreanDate(rawDate);
            final String time = formatAmPm(m['scheduledTime'] as String);
            final int enteredCount = m['enteredCount'] as int;
            final String image = m['imageSrc'] as String;
            final bool isReservation = m['isReservation'] as bool;

            return HistoryClubCard(
              reviewStatus: status,
              clubName: clubName,
              scheduledDate: formattedDate,
              scheduledTime: time,
              enteredCount: enteredCount,
              imageSrc: image,
              isReservation: isReservation,
            );
          },
        );
      },
    );
  }
}
