import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/screens/purchase_page.dart';
import 'package:vybe/features/table_reservation_page/widgets/table_reservation_page/booking_tile.dart';
import 'package:vybe/features/table_reservation_page/widgets/table_reservation_page/information_input.dart';
import 'package:vybe/features/table_reservation_page/widgets/table_reservation_page/people_count_section.dart';
import 'package:vybe/features/table_reservation_page/widgets/table_reservation_page/reservation_calendar.dart';
import 'package:vybe/features/table_reservation_page/widgets/table_reservation_page/sold_table_dialog.dart';
import 'package:vybe/features/table_reservation_page/widgets/table_reservation_page/table_select_section.dart';
import 'package:vybe/features/table_reservation_page/widgets/table_reservation_page/time_section.dart';
import 'menu_order_screen.dart';

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
  late final TextEditingController _nameController;
  late final TextEditingController _contactController;
  final Set<CartEntry> _cartItems = <CartEntry>{};

  /// 장바구니 항목을 복제해 상태 공유를 방지한다.
  Set<CartEntry> _cloneCartItems(Iterable<CartEntry> items) =>
      items.map((entry) => entry.copyWith()).toSet();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _contactController = TextEditingController();
    // 로케일 포맷(상단 월/연도 등) 한국어
    Intl.defaultLocale = 'ko_KR';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  /// 인원 수를 한 명 늘린다.
  void _incrementGuestCount() {
    setState(() => _guestCount += 1);
  }

  /// 인원 수를 줄이되 1명 이하로는 내려가지 않는다.
  void _decrementGuestCount() {
    if (_guestCount <= 1) return;
    setState(() => _guestCount -= 1);
  }

  /// 테이블 버튼 터치 시 판매 여부를 검사해 선택한다.
  void _handleTableTap(String tableId) {
    final isSold = _soldTableIds.contains(tableId);
    if (isSold) {
      _showSoldTableDialog();
      return;
    }
    setState(() => _selectedTableId = tableId);
  }

  /// 시간 슬롯 선택
  void _handleTimeTap(String time) => setState(() => _selectedTimeSlot = time);

  /// 예약자/연락처 입력 시 호출되어 버튼 상태를 갱신한다.
  void _handleReservationInfoChanged(String _) => setState(() {});

  /// 메뉴 주문 화면을 열어 장바구니를 갱신한다.
  Future<void> _openMenuOrder() async {
    final result = await Navigator.of(context).push<Set<CartEntry>>(
      MaterialPageRoute(
        builder: (_) =>
            MenuOrderScreen(initialItems: _cloneCartItems(_cartItems)),
      ),
    );

    if (!mounted) {
      return;
    }

    if (result != null) {
      setState(() {
        _cartItems
          ..clear()
          ..addAll(_cloneCartItems(result));
      });
    }
  }

  /// 이미 판매된 테이블 선택 시 안내 다이얼로그 출력.
  Future<void> _showSoldTableDialog() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const SoldTableDialog(),
    );
  }

  /// 전체 예약 화면 UI를 구성한다.
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
    final bool isNameFilled = _nameController.text.trim().isNotEmpty;
    final bool isContactFilled = _contactController.text.trim().isNotEmpty;
    final bool isReservationInfoFilled = isNameFilled && isContactFilled;
    final bool isAllSelected =
        _selectedDay != null &&
        _guestCount > 0 &&
        _selectedTableId != null &&
        _selectedTimeSlot != null &&
        isReservationInfoFilled;
    final Color payButtonColor = isAllSelected
        ? AppColors.appPurpleColor
        : const Color(0xFF2F1A5A);
    final String orderTitle = _cartItems.isEmpty
        ? '주문하기'
        : '주문하기 (${_cartItems.length}개 담김)';

    // 예약 가능한 야간 시간 슬롯
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          widget.clubName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
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
                      controller: _nameController,
                      onChanged: _handleReservationInfoChanged,
                      isFilled: isNameFilled,
                    ),
                    SizedBox(height: 24.h),
                    InformationInput(
                      inputTitle: "연락처",
                      hintText: "숫자만 입력해주세요.",
                      controller: _contactController,
                      onChanged: _handleReservationInfoChanged,
                      isFilled: isContactFilled,
                      inputFormatters: const [HyphenPhoneFormatter()],
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
                    BookingTile(
                      title: dateTitle,
                      leadingAsset:
                          "assets/icons/table_reservation_page/calendar.svg",
                      child: ReservationCalendar(
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
                    BookingTile(
                      title: peopleTitle,
                      leadingAsset:
                          "assets/icons/table_reservation_page/person.svg",
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
                    BookingTile(
                      title: tableTitle,
                      leadingAsset:
                          "assets/icons/table_reservation_page/table.svg",
                      child: TableSelectSection(
                        selectedTableId: _selectedTableId,
                        soldTableIds: _soldTableIds,
                        onTableTap: _handleTableTap,
                      ),
                    ),
                    BookingTile(
                      title: timeTitle,
                      leadingAsset:
                          "assets/icons/table_reservation_page/time.svg",
                      child: TimeSection(
                        slots: nightSlots,
                        selectedTime: _selectedTimeSlot,
                        onTimeSelected: _handleTimeTap,
                      ),
                    ),
                    BookingTile(
                      title: orderTitle,
                      leadingAsset:
                          "assets/icons/table_reservation_page/receipt.svg",
                      trailingArrow: true,
                      onTap: _openMenuOrder,
                      child: Column(),
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
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (!isAllSelected) {
                      return;
                    }

                    final reservationData = <Map<String, dynamic>>{
                      {
                        'clubName': widget.clubName,
                        'reservationName': _nameController.text.trim(),
                        'contactNumber': _contactController.text.trim(),
                        'reservationDate': _selectedDay!,
                        'guestCount': _guestCount,
                        'tableId': _selectedTableId!,
                        'timeSlot': _selectedTimeSlot!,
                        'cartItems': _cloneCartItems(_cartItems),
                      },
                    };

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PurchasePage(reservationData: reservationData),
                      ),
                    );
                  },
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
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
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
