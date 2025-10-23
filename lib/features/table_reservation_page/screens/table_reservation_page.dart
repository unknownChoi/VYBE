import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vybe/core/app_colors.dart';

class TableReservationPage extends StatefulWidget {
  const TableReservationPage({super.key, required this.clubName});

  final String clubName;

  @override
  State<TableReservationPage> createState() => _TableReservationPageState();
}

class _TableReservationPageState extends State<TableReservationPage> {
  // ── 달력 상태
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // 로케일 포맷(상단 월/연도 등) 한국어
    Intl.defaultLocale = 'ko_KR';
  }

  @override
  Widget build(BuildContext context) {
    final dateTitle = _selectedDay != null
        ? DateFormat('M월 d일 (E)').format(_selectedDay!)
        : '날짜 선택';

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 24.w + 48.w,
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          widget.clubName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
            height: 1.10,
            letterSpacing: -0.50,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                InformationInput(inputTitle: "예약자명", hintText: "이름을 입력해주세요."),
                SizedBox(height: 24.h),
                InformationInput(inputTitle: "연락처", hintText: "숫자만 입력해주세요."),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 8.h,
            decoration: BoxDecoration(color: Color(0xFF2F2F33)),
          ),
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                _BookingTileSimple(
                  title: dateTitle,
                  leading: Icon(Icons.calendar_month_rounded, size: 22.r),
                  child: _CalendarSection(
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onPageChanged: (focused) {
                      setState(() => _focusedDay = focused);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InformationInput extends StatelessWidget {
  const InformationInput({
    super.key,
    required this.inputTitle,
    required this.hintText,
  });

  final String inputTitle;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              inputTitle,
              style: TextStyle(
                color: const Color(0xFFECECEC) /* Gray200 */,
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.25,
                letterSpacing: -0.80,
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              height: 40.h,
              child: TextField(
                keyboardType: inputTitle == "예약자명"
                    ? TextInputType.name
                    : TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: const Color(0xFFCACACB) /* Gray400 */,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                    letterSpacing: -0.70,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(
                      color: const Color(0xFF2F2F33),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(
                      color: const Color(0xFF2F2F33),
                      width: 1,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: const Color(0xFFCACACB) /* Gray400 */,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  height: 1.14,
                  letterSpacing: -0.70,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(DateTime focusedDay) onPageChanged;

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

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: TableCalendar(
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
                color: Colors.white.withOpacity(0.4),
                fontSize: 14.sp,
              ),
              todayDecoration: const BoxDecoration(),
              todayTextStyle: TextStyle(color: todayColor, fontSize: 14.sp),
              holidayDecoration: const BoxDecoration(),
              selectedDecoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              selectedTextStyle: const TextStyle(color: Colors.white),
            ),
            holidayPredicate: (day) =>
                day.weekday == DateTime.saturday ||
                day.weekday == DateTime.sunday,
            enabledDayPredicate: (day) => !day.isBefore(firstAllowedDay),
            selectedDayPredicate: (day) => _isSameDay(selectedDay, day),
            onDaySelected: onDaySelected,
            onPageChanged: (newFocusedDay) {
              final clamped = newFocusedDay.isBefore(firstAllowedDay)
                  ? firstAllowedDay
                  : newFocusedDay;
              onPageChanged(clamped);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final isOutside = day.month != focusedDay.month;
                final isWeekend =
                    day.weekday == DateTime.saturday ||
                    day.weekday == DateTime.sunday;
                final baseColor = isWeekend ? holidayColor : textColor;
                final color = isOutside
                    ? baseColor.withOpacity(0.35)
                    : baseColor;
                final isDisabled = day.isBefore(firstAllowedDay);
                return _buildDayCell(
                  dayText: '${day.day}',
                  color: color,
                  isDisabled: isDisabled,
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return _buildDayCell(
                  dayText: '${day.day}',
                  color: todayColor,
                  isDisabled: false,
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildDayCell({
    required String dayText,
    required Color color,
    required bool isDisabled,
  }) {
    final displayColor = isDisabled ? color.withOpacity(0.25) : color;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayText,
              style: TextStyle(color: displayColor, fontSize: 14.sp),
            ),
          ],
        ),
      ),
    );
  }
}

/// 공용 아코디언 타일
class _BookingTileSimple extends StatelessWidget {
  const _BookingTileSimple({
    required this.title,
    required this.child,
    this.leading,
    this.trailingArrow = false,
  });

  final String title;
  final Widget child;
  final Widget? leading;
  final bool trailingArrow;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF2F2F33), width: 1.w),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 14.w),
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          leading: leading,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          trailing: trailingArrow
              ? const Icon(Icons.chevron_right_rounded, color: Colors.white)
              : null,
          children: [SizedBox(width: double.infinity, child: child)],
        ),
      ),
    );
  }
}

/// 비활성 슬롯 칩(스타일 용)
class _SlotChip extends StatelessWidget {
  const _SlotChip(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text, style: const TextStyle(color: Colors.white)),
      backgroundColor: const Color(0xFF242427),
      side: BorderSide(color: const Color(0xFF2C2C2F), width: 1.w),
    );
  }
}
