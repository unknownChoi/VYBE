import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/widgets/custom_divider.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/widgets/cart_items_list_view.dart';

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
        ? DateFormat('MM월 dd일 (E)', 'ko_KR').format(_reservationDate!)
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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '예약자명',
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: -0.80,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _reservationName,
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: -0.80,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Text(
                      '연락처',
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: -0.80,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _contactNumber,
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: -0.80,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Text(
                      '예약 일시',
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: -0.80,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: const Color(0xFFECECEC) /* Gray200 */,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                            letterSpacing: -0.80,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          'assets/icons/common/dot.svg',
                          color: const Color(0xFFECECEC),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _timeSlot,
                          style: TextStyle(
                            color: const Color(0xFFECECEC) /* Gray200 */,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                            letterSpacing: -0.80,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Text(
                      '테이블',
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: -0.80,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$_tableId번 테이블',
                      style: TextStyle(
                        color: const Color(0xFFECECEC) /* Gray200 */,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.25,
                        letterSpacing: -0.80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const CustomDivider(),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('주문 내역'),
                  Expanded(
                    child: _cartItems.isEmpty
                        ? Center(
                            child: Text(
                              '장바구니가 비어 있습니다.',
                              style: TextStyle(
                                color: const Color(0xFFECECEC),
                                fontSize: 16.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        : CartItemsListView(
                            entries: _cartItems,
                            padding: EdgeInsets.zero,
                          ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Text(
                        '총 결제 금액',
                        style: TextStyle(
                          color: const Color(0xFFBEBEC0),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
