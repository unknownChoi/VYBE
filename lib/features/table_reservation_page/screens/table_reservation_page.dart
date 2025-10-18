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
    const divider = Color(0xFF2A2A2D);

    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          widget.clubName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── 스크롤 본문
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 6.h),
                  Text(
                    '예약자명',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    cursorColor: const Color(0xFF6C3BFF),
                    decoration: InputDecoration(
                      hintText: '이름을 입력해주세요.',
                      hintStyle: TextStyle(
                        color: const Color(0xFF9A9A9E),
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1B1B1D),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF2C2C2F),
                          width: 1.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF6C3BFF),
                          width: 1.2.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '연락처',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    cursorColor: const Color(0xFF6C3BFF),
                    decoration: InputDecoration(
                      hintText: '숫자만 입력해주세요.',
                      hintStyle: TextStyle(
                        color: const Color(0xFF9A9A9E),
                        fontSize: 14.sp,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF1B1B1D),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF2C2C2F),
                          width: 1.w,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: const Color(0xFF6C3BFF),
                          width: 1.2.w,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Container(height: 8.h, color: divider),
                  SizedBox(height: 12.h),

                  // ── 아코디언 섹션들
                  Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: const Color(0xFF2C2C2F),
                      listTileTheme: const ListTileThemeData(
                        iconColor: Colors.white,
                        textColor: Colors.white,
                      ),
                    ),
                    child: Column(
                      children: [
                        // ============ 날짜 선택 (달력 내장) ============
                        _BookingTileSimple(
                          title: '날짜 선택',
                          leading: Icon(
                            Icons.calendar_month_rounded,
                            size: 22.r,
                          ),
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

                        // ============================================
                        _BookingTileSimple(
                          title: '인원 선택',
                          leading: Icon(Icons.person_rounded, size: 22.r),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Text(
                              '인원을 선택하세요',
                              style: TextStyle(
                                color: const Color(0xFF9A9A9E),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        _BookingTileSimple(
                          title: '테이블 선택',
                          leading: Icon(Icons.wine_bar_rounded, size: 22.r),
                          child: Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: List.generate(
                              6,
                              (i) => Chip(
                                label: Text(
                                  'T-${i + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                backgroundColor: const Color(0xFF242427),
                                side: const BorderSide(
                                  color: Color(0xFF2C2C2F),
                                ),
                              ),
                            ),
                          ),
                        ),
                        _BookingTileSimple(
                          title: '시간 선택',
                          leading: Icon(
                            Icons.access_time_filled_rounded,
                            size: 22.r,
                          ),
                          child: Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: const [
                              _SlotChip('오후 8:00'),
                              _SlotChip('오후 8:30'),
                              _SlotChip('오후 9:00'),
                              _SlotChip('오후 9:30'),
                            ],
                          ),
                        ),
                        _BookingTileSimple(
                          title: '주문하기',
                          leading: Icon(Icons.receipt_long_rounded, size: 22.r),
                          trailingArrow: true,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Text(
                              '메뉴를 선택해 주세요',
                              style: TextStyle(
                                color: const Color(0xFF9A9A9E),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── 하단 고정 버튼
          SafeArea(
            top: false,
            child: Container(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(color: const Color(0xFF2C2C2F), width: 1.w),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A5A5F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text('취소하기', style: TextStyle(fontSize: 15.sp)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C3BFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          // TODO: 결제 플로우 연결
                          // 선택된 날짜: _selectedDay
                        },
                        child: Text('결제하기', style: TextStyle(fontSize: 15.sp)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────
/// 달력 섹션 위젯 (TableCalendar 커스터마이즈)
/// ─────────────────────────────────────────────────────────────────────────
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
    const card = Color(0xFF1B1B1D);
    const border = Color(0xFF2C2C2F);
    const primary = Color(0xFF6C3BFF);
    const holidayColor = Color(0xFFFF6B6B);
    const textColor = Colors.white;
    final todayColor = AppColors.appGreenColor;

    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: border, width: 1.w),
      ),
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 8.w, 12.h),
      child: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2010, 1, 1),
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
            day.weekday == DateTime.saturday || day.weekday == DateTime.sunday,
        selectedDayPredicate: (day) => _isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,

        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final isOutside = day.month != focusedDay.month;
            final isWeekend =
                day.weekday == DateTime.saturday ||
                day.weekday == DateTime.sunday;
            final baseColor = isWeekend ? holidayColor : textColor;
            final color = isOutside ? baseColor.withOpacity(0.35) : baseColor;
            return _buildDayCell(dayText: '${day.day}', color: color);
          },
          todayBuilder: (context, day, focusedDay) {
            return _buildDayCell(dayText: '${day.day}', color: todayColor);
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
    );
  }

  Widget _buildDayCell({required String dayText, required Color color}) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dayText,
              style: TextStyle(color: color, fontSize: 14.sp),
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
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1D),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF2C2C2F), width: 1.w),
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
          childrenPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 8.h,
          ),
          children: [child],
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
