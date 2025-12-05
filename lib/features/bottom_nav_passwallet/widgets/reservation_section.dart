import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';
import 'package:vybe/features/bottom_nav_passwallet/utils/passwallet_formatters.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/club_cards/reservation_club_card.dart';

class ReservationSection extends StatefulWidget {
  const ReservationSection({super.key});

  @override
  State<ReservationSection> createState() => _ReservationSectionState();
}

class _ReservationSectionState extends State<ReservationSection> {
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    _items = passWalletReservationData;
  }

  void _handleDelete(int index) {
    if (index < 0 || index >= _items.length) return;
    setState(() {
      _items.removeAt(index); // 원본 mock 데이터도 함께 삭제됨
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _items.length * 2,
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
        final m = _items[i];

        final ReservationStatus status = m['status'] as ReservationStatus;
        final String clubName = m['clubName'] as String;
        final String rawDate = m['scheduledDate'] as String;
        final String formattedDate = formatKoreanDate(rawDate);
        final String time = formatAmPm(m['scheduledTime'] as String);
        final int enteredCount = m['enteredCount'] as int;
        final String image = m['imageSrc'] as String;

        return ReservationClubCard(
          status: status,
          clubName: clubName,
          scheduledDate: formattedDate,
          scheduledTime: time,
          enteredCount: enteredCount,
          imageSrc: image,
          onDelete: status == ReservationStatus.canceled
              ? () => _handleDelete(i)
              : null,
        );
      },
    );
  }
}
