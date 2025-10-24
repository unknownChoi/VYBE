import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/core/dialong_widget.dart';
import 'package:vybe/features/bottom_nav_passwallet/widgets/dialog/dialog_button.dart';

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
  int _guestCount = 1;
  bool _hasOpenedPeopleTile = false;
  String? _selectedTableId;
  final Set<String> _soldTableIds = {'3', '5', '14'};
  String? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    // 로케일 포맷(상단 월/연도 등) 한국어
    Intl.defaultLocale = 'ko_KR';
  }

  void _incrementGuestCount() {
    setState(() {
      _guestCount += 1;
    });
  }

  void _decrementGuestCount() {
    if (_guestCount <= 1) return;
    setState(() {
      _guestCount -= 1;
    });
  }

  void _handleTableTap(String tableId) {
    final isSold = _soldTableIds.contains(tableId);
    if (isSold) {
      _showSoldTableDialog();
      return;
    }
    setState(() => _selectedTableId = tableId);
  }

  void _handleTimeTap(String time) {
    setState(() => _selectedTimeSlot = time);
  }

  Future<void> _showSoldTableDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const SoldTableDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateTitle = _selectedDay != null
        ? DateFormat('M월 d일 (E)').format(_selectedDay!)
        : '날짜 선택';
    final peopleTitle = _hasOpenedPeopleTile ? '$_guestCount명' : '인원 선택';
    final tableTitle = _selectedTableId != null
        ? '$_selectedTableId번 테이블'
        : '테이블 선택';
    final timeTitle = _selectedTimeSlot ?? '시간 선택';
    final bool isAllSelected =
        _selectedDay != null &&
        _guestCount > 0 &&
        _selectedTableId != null &&
        _selectedTimeSlot != null;
    final Color payButtonColor = isAllSelected
        ? AppColors.appPurpleColor
        : const Color(0xFF2F1A5A);

    const List<String> nightSlots = [
      '오후 11:00',
      '오후 11:30',
      '오전 12:00',
      '오전 12:30',
      '오전 1:00',
      '오전 1:30',
      '오전 2:00',
      '오전 2:30',
      '오전 3:00',
      '오전 3:30',
      '오전 4:00',
      '오전 4:30',
      '오전 5:00',
    ];
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
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    InformationInput(
                      inputTitle: "예약자명",
                      hintText: "이름을 입력해주세요.",
                    ),
                    SizedBox(height: 24.h),
                    InformationInput(
                      inputTitle: "연락처",
                      hintText: "숫자만 입력해주세요.",
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 8.h,
                decoration: BoxDecoration(color: Color(0xFF2F2F33)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  children: [
                    _BookingTileSimple(
                      title: dateTitle,
                      leading:
                          "assets/icons/table_reservation_page/calendar.svg",
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
                    _BookingTileSimple(
                      title: peopleTitle,
                      leading: "assets/icons/table_reservation_page/person.svg",
                      child: PeopleCountSection(
                        count: _guestCount,
                        onIncrement: _incrementGuestCount,
                        onDecrement: _decrementGuestCount,
                      ),
                      onExpansionChanged: (isExpanded) {
                        if (!isExpanded) return;
                        if (_hasOpenedPeopleTile) return;
                        setState(() => _hasOpenedPeopleTile = true);
                      },
                    ),
                    _BookingTileSimple(
                      title: tableTitle,
                      leading: "assets/icons/table_reservation_page/table.svg",
                      child: TableSelectSection(
                        selectedTableId: _selectedTableId,
                        soldTableIds: _soldTableIds,
                        onTableTap: _handleTableTap,
                      ),
                    ),
                    _BookingTileSimple(
                      title: timeTitle,
                      leading: "assets/icons/table_reservation_page/time.svg",
                      child: TimeSection(
                        slots: nightSlots,
                        selectedTime: _selectedTimeSlot,
                        onTimeSelected: _handleTimeTap,
                      ),
                    ),
                    _BookingTileSimple(
                      title: "주문하기",
                      leading:
                          "assets/icons/table_reservation_page/receipt.svg",
                      child: TimeSection(
                        slots: nightSlots,
                        selectedTime: _selectedTimeSlot,
                        onTimeSelected: _handleTimeTap,
                      ),
                    ),
                    SizedBox(height: 97.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          height: 40.h,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Color(0xFF535355),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      '취소하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: payButtonColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      '결제하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 시간 선택 섹션
class TimeSection extends StatelessWidget {
  const TimeSection({
    super.key,
    required this.slots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  final List<String> slots;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Row(
          children: [
            ...slots.map((time) {
              final bool isSelected = time == selectedTime;
              final Color backgroundColor = isSelected
                  ? AppColors.appGreenColor
                  : Colors.transparent;
              final Color borderColor = isSelected
                  ? AppColors.appGreenColor
                  : const Color(0xFFECECEC);
              final Color textColor = isSelected
                  ? const Color(0xFF0E0E10)
                  : const Color(0xFFECECEC);

              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTimeSelected(time),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 11.h,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.12,
                        letterSpacing: -0.80,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// 테이블 선택 섹션
class TableSelectSection extends StatelessWidget {
  const TableSelectSection({
    super.key,
    required this.selectedTableId,
    required this.soldTableIds,
    required this.onTableTap,
  });

  final String? selectedTableId;
  final Set<String> soldTableIds;
  final void Function(String tableId) onTableTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          const _TableLegend(),
          SizedBox(height: 24.h),
          TableSection(
            selectedTableId: selectedTableId,
            soldTableIds: soldTableIds,
            onTableTap: onTableTap,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

class _TableLegend extends StatelessWidget {
  const _TableLegend();

  @override
  Widget build(BuildContext context) {
    Widget buildInfoRow({
      required Color color,
      required String label,
      required List<String> details,
    }) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFFECECEC),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.14,
              letterSpacing: -0.70,
            ),
          ),
          for (final detail in details) ...[
            SizedBox(width: 4.w),
            SvgPicture.asset(
              width: 2.w,
              color: const Color(0xFFD9D9D9),
              'assets/icons/common/dot.svg',
            ),
            SizedBox(width: 4.w),
            Text(
              detail,
              style: TextStyle(
                color: const Color(0xFFECECEC),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.14,
                letterSpacing: -0.70,
              ),
            ),
          ],
        ],
      );
    }

    return Container(
      padding: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.w, color: const Color(0xFF2F2F33)),
        ),
      ),
      child: Column(
        children: [
          buildInfoRow(
            color: AppColors.appPurpleColor,
            label: '룸',
            details: ['4명 이상', '최소 주문 ₩150,000'],
          ),
          SizedBox(height: 8.h),
          buildInfoRow(
            color: AppColors.appGreenColor,
            label: '테이블',
            details: ['2 ~ 4명', '최소 주문 ₩70,000'],
          ),
          SizedBox(height: 8.h),
          buildInfoRow(
            color: const Color(0xFFCACACB),
            label: '예약 완료',
            details: const [],
          ),
        ],
      ),
    );
  }
}

class TableSection extends StatelessWidget {
  const TableSection({
    super.key,
    required this.selectedTableId,
    required this.soldTableIds,
    required this.onTableTap,
  });

  final String? selectedTableId;
  final Set<String> soldTableIds;
  final void Function(String tableId) onTableTap;

  @override
  Widget build(BuildContext context) {
    final smallPadding = EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w);

    final rows = <List<_TableMeta>>[
      [
        _TableMeta(
          id: '1',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
        ),
        _TableMeta(
          id: '2',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
        ),
        _TableMeta(
          id: '3',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
        ),
        _TableMeta(
          id: '4',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
        ),
      ],
      [
        _TableMeta(
          id: '5',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
          quarterTurns: 1,
        ),
        _TableMeta(
          id: '6',
          assetPath: 'assets/icons/table_reservation_page/table_select.svg',
          width: 42.w,
          height: 42.h,
          padding: smallPadding,
          category: _TableCategory.table,
        ),
        _TableMeta(
          id: '7',
          assetPath: 'assets/icons/table_reservation_page/table_select.svg',
          width: 42.w,
          height: 42.h,
          padding: smallPadding,
          category: _TableCategory.table,
        ),
        _TableMeta(
          id: '8',
          assetPath: 'assets/icons/table_reservation_page/table_select.svg',
          width: 42.w,
          height: 42.h,
          padding: smallPadding,
          category: _TableCategory.table,
        ),
        _TableMeta(
          id: '9',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
          quarterTurns: 1,
        ),
      ],
      [
        _TableMeta(
          id: '10',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
          quarterTurns: 1,
        ),
        _TableMeta(
          id: '11',
          assetPath: 'assets/icons/table_reservation_page/table_select.svg',
          width: 42.w,
          height: 42.h,
          padding: smallPadding,
          category: _TableCategory.table,
        ),
        _TableMeta(
          id: '12',
          assetPath: 'assets/icons/table_reservation_page/table_select.svg',
          width: 42.w,
          height: 42.h,
          padding: smallPadding,
          category: _TableCategory.table,
        ),
        _TableMeta(
          id: '13',
          assetPath: 'assets/icons/table_reservation_page/table_select.svg',
          width: 42.w,
          height: 42.h,
          padding: smallPadding,
          category: _TableCategory.table,
        ),
        _TableMeta(
          id: '14',
          assetPath: 'assets/icons/table_reservation_page/table(1)_select.svg',
          width: 27.w,
          height: 23.h,
          padding: smallPadding,
          category: _TableCategory.room,
          quarterTurns: 1,
        ),
      ],
    ];

    return Column(
      children: [
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (
                var columnIndex = 0;
                columnIndex < rows[rowIndex].length;
                columnIndex++
              ) ...[
                if (columnIndex > 0) SizedBox(width: 14.w),
                _TableButton(
                  meta: rows[rowIndex][columnIndex],
                  isSelected: selectedTableId == rows[rowIndex][columnIndex].id,
                  isSold: soldTableIds.contains(rows[rowIndex][columnIndex].id),
                  onTap: onTableTap,
                ),
              ],
            ],
          ),
          if (rowIndex < rows.length - 1) SizedBox(height: 8.h),
        ],
      ],
    );
  }
}

class _TableButton extends StatelessWidget {
  const _TableButton({
    required this.meta,
    required this.isSelected,
    required this.isSold,
    required this.onTap,
  });

  final _TableMeta meta;
  final bool isSelected;
  final bool isSold;
  final void Function(String tableId) onTap;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = meta.category == _TableCategory.room
        ? AppColors.appPurpleColor
        : AppColors.appGreenColor;
    final Color iconColor = isSold ? const Color(0xFFCACACB) : baseColor;

    double borderWidth = 0;
    Color borderColor = Colors.transparent;
    Color backgroundColor = Colors.transparent;

    if (isSold) {
      borderWidth = 1.w;
      borderColor = const Color(0xFFCACACB);
    } else if (isSelected) {
      borderWidth = 2.w;
      borderColor = baseColor;
      backgroundColor = baseColor.withOpacity(0.18);
    } else if (meta.category == _TableCategory.room) {
      borderWidth = 1.w;
      borderColor = baseColor;
    }

    final table = Container(
      padding:
          meta.padding ?? EdgeInsets.symmetric(vertical: 5.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6.r),
        border: borderWidth > 0
            ? Border.all(color: borderColor, width: borderWidth)
            : null,
      ),
      child: Opacity(
        opacity: isSold ? 0.55 : 1,
        child: SvgPicture.asset(
          meta.assetPath,
          width: meta.width,
          height: meta.height,
          color: iconColor,
        ),
      ),
    );

    final widget = meta.quarterTurns == 0
        ? table
        : RotatedBox(quarterTurns: meta.quarterTurns, child: table);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(meta.id),
      child: widget,
    );
  }
}

enum _TableCategory { room, table }

class _TableMeta {
  const _TableMeta({
    required this.id,
    required this.assetPath,
    required this.width,
    required this.height,
    required this.category,
    this.quarterTurns = 0,
    this.padding,
  });

  final String id;
  final String assetPath;
  final double width;
  final double height;
  final _TableCategory category;
  final int quarterTurns;
  final EdgeInsets? padding;
}

class SoldTableDialog extends StatelessWidget {
  const SoldTableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTextStyles.dialogTitleTextStyle;
    final descriptionStyle = AppTextStyles.dialogDescriptionTextStyle;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: DialongWidget(
        dialogWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '이미 판매된 테이블입니다',
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            SizedBox(height: 12.h),
            Text(
              '다른 테이블을 선택해주세요.',
              textAlign: TextAlign.center,
              style: descriptionStyle,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                DialonButton(
                  buttonText: '확인',
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PeopleCountSection extends StatelessWidget {
  const PeopleCountSection({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
    this.minCount = 1,
  });

  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final int minCount;

  @override
  Widget build(BuildContext context) {
    final canDecrement = count > minCount;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onIncrement,
            child: Container(
              height: 40.h,
              padding: EdgeInsets.symmetric(vertical: 9.h, horizontal: 108.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2F1A5A),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(width: 1.w, color: const Color(0xFF7731FE)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '친구 추가',
                    style: TextStyle(
                      color: const Color(0xFFD9C5FF),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.14,
                      letterSpacing: -0.35,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SvgPicture.asset(width: 11.w, 'assets/icons/common/plus.svg'),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: canDecrement ? onDecrement : null,
                child: Opacity(
                  opacity: canDecrement ? 1 : 0.35,
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF404042),
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        width: 18.w,
                        'assets/icons/common/minus.svg',
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFB5FF60),
                      fontSize: 32,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.06,
                      letterSpacing: -0.80,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '명',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFECECEC),
                      fontSize: 20,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.10,
                      letterSpacing: -0.50,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onIncrement,
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF404042),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      width: 18.w,
                      'assets/icons/common/plus.svg',
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// 정보 입력 창
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

// 달력 섹션
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
    this.onExpansionChanged,
  });

  final String title;
  final Widget child;
  final String? leading;
  final bool trailingArrow;
  final ValueChanged<bool>? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF2F2F33), width: 1.w),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          collapsedIconColor: Colors.white,
          iconColor: Colors.white,
          leading: leading != null ? SvgPicture.asset(leading!) : null,
          childrenPadding: EdgeInsets.zero,
          title: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          onExpansionChanged: onExpansionChanged,
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
