import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReservationInfoSection extends StatelessWidget {
  const ReservationInfoSection({
    super.key,
    required this.items,
  });

  final List<_ReservationInfoItem> items;

  @override
  /// Builds the widget for context).
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];
        return Padding(
          padding: EdgeInsets.only(bottom: index < items.length - 1 ? 24.h : 0),
          child: Row(
            children: [
              Text(
                item.label,
                style: TextStyle(
                  color: const Color(0xFFECECEC),
                  fontSize: 16.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                  letterSpacing: -0.80,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  item.value,
                  style: TextStyle(
                    color: const Color(0xFFECECEC),
                    fontSize: 16.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    letterSpacing: -0.80,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ReservationInfoItem {
  const _ReservationInfoItem({required this.label, required this.value});

  final String label;
  final String value;
}

List<_ReservationInfoItem> buildReservationInfoItems({
  required String name,
  required String contact,
  required String dateText,
  required String timeSlot,
  required String tableId,
}) {
  return [
    _ReservationInfoItem(label: '예약자명', value: name),
    _ReservationInfoItem(label: '연락처', value: contact),
    _ReservationInfoItem(label: '예약 일시', value: '$dateText $timeSlot'),
    _ReservationInfoItem(label: '테이블', value: '${tableId}번 테이블'),
  ];
}