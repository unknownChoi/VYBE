import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vybe/core/app_colors.dart';

/// 예약 날짜를 선택하는 TableCalendar 래퍼.
class ReservationCalendar extends StatelessWidget {
  const ReservationCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  bool _isSameDay(DateTime? a, DateTime? b) =>
      a != null && b != null && isSameDay(a, b);

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF6C3BFF);
    const holidayColor = Color(0xFFFF6B6B);
    const textColor = Colors.white;
    final todayColor = AppColors.appGreenColor;
    final now = DateTime.now();
    final firstAllowedDay = DateTime(now.year, now.month, now.day);

    return TableCalendar(
      locale: 'ko_KR',
      firstDay: firstAllowedDay,
      lastDay: DateTime.utc(2035, 12, 31),
      focusedDay: focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) =>
            DateFormat('yyyy년 M월', locale).format(date),
        titleTextStyle: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
        ),
        leftChevronIcon: const Icon(
          Icons.chevron_left_rounded,
          color: textColor,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right_rounded,
          color: textColor,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: textColor, fontSize: 12.sp),
        weekendStyle: TextStyle(color: holidayColor, fontSize: 12.sp),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        defaultTextStyle: TextStyle(color: textColor, fontSize: 14.sp),
        weekendTextStyle: TextStyle(color: holidayColor, fontSize: 14.sp),
        holidayTextStyle: TextStyle(color: holidayColor, fontSize: 14.sp),
        disabledTextStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 14.sp,
        ),

        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        outsideDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        disabledDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        todayDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        todayTextStyle: TextStyle(color: todayColor, fontSize: 14.sp),
        holidayDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
        ),
        selectedDecoration: BoxDecoration(
          color: primary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12.r),
        ),
        selectedTextStyle: const TextStyle(color: Colors.white),
      ),
      holidayPredicate: (day) =>
          day.weekday == DateTime.saturday || day.weekday == DateTime.sunday,
      enabledDayPredicate: (day) => !day.isBefore(firstAllowedDay),
      selectedDayPredicate: (day) => _isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      onPageChanged: (newFocusedDay) {
        final clamped = newFocusedDay.isBefore(firstAllowedDay)
            ? firstAllowedDay
            : newFocusedDay;
        onPageChanged(clamped);
      },
    );
  }
}
