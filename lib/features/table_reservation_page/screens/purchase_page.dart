import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';

class PurchasePage extends StatefulWidget {
  PurchasePage({super.key, required Set<Map<String, dynamic>> reservationData})
    : reservationData = reservationData.map<Map<String, dynamic>>((entry) {
        final cloned = Map<String, dynamic>.from(entry);
        final cartItems = entry['cartItems'];
        if (cartItems is Set<CartEntry>) {
          cloned['cartItems'] = cartItems
              .map((item) => item.copyWith())
              .toSet();
        }
        return cloned;
      }).toSet();

  final Set<Map<String, dynamic>> reservationData;

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final NumberFormat _priceFormatter = NumberFormat('#,##0');

  Map<String, dynamic> get _reservation => widget.reservationData.isNotEmpty
      ? widget.reservationData.first
      : const <String, dynamic>{};

  String get _clubName => _reservation['clubName'] as String? ?? '';
  String get _reservationName =>
      _reservation['reservationName'] as String? ?? '';
  String get _contactNumber => _reservation['contactNumber'] as String? ?? '';
  DateTime? get _reservationDate =>
      _reservation['reservationDate'] as DateTime?;
  int get _guestCount => _reservation['guestCount'] as int? ?? 0;
  String get _tableId => _reservation['tableId']?.toString() ?? '';
  String get _timeSlot => _reservation['timeSlot'] as String? ?? '';

  Set<CartEntry> get _cartItemSet {
    final value = _reservation['cartItems'];
    if (value is Set<CartEntry>) {
      return value.map((item) => item).toSet();
    }
    if (value is Iterable<CartEntry>) {
      return value.map((item) => item).toSet();
    }
    return {};
  }

  List<CartEntry> get _cartItems => _cartItemSet.toList();

  num get _orderTotal =>
      _cartItemSet.fold<num>(0, (sum, item) => sum + item.totalPrice);

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFFBEBEC0),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(CartEntry entry) {
    final options = entry.options.isEmpty
        ? '옵션 없음'
        : entry.options.map((opt) => opt['name']).join(', ');
    final totalPrice = _priceFormatter.format(entry.totalPrice);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.menuName} x${entry.quantity}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  options,
                  style: TextStyle(
                    color: const Color(0xFFBEBEC0),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            '$totalPrice원',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _reservationDate != null
        ? DateFormat('M월 d일 (E)').format(_reservationDate!)
        : '-';
    final totalPrice = _priceFormatter.format(_orderTotal);
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
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          _clubName,
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('예약 정보'),
            _buildInfoRow(label: '예약자명', value: _reservationName),
            _buildInfoRow(label: '연락처', value: _contactNumber),
            _buildInfoRow(label: '날짜', value: formattedDate),
            _buildInfoRow(label: '인원', value: '$_guestCount명'),
            _buildInfoRow(label: '테이블', value: '$_tableId번 테이블'),
            _buildInfoRow(label: '시간', value: _timeSlot),
            SizedBox(height: 32.h),
            _buildSectionTitle('선택한 메뉴'),
            if (_cartItems.isEmpty)
              Text(
                '선택한 메뉴가 없습니다.',
                style: TextStyle(
                  color: const Color(0xFFBEBEC0),
                  fontSize: 14.sp,
                ),
              )
            else ...[
              ..._cartItems.map(_buildMenuItem),
              SizedBox(height: 16.h),
              Divider(color: const Color(0xFF2F2F33), thickness: 1),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '총 결제 금액',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$totalPrice원',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
