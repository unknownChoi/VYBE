import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/route_names.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key, required this.reservationData});

  final Map<String, dynamic> reservationData;
  static final NumberFormat _priceFormatter = NumberFormat('#,##0');

  String get _clubName => reservationData['clubName'] as String? ?? '';
  DateTime? get _reservationDate =>
      reservationData['reservationDate'] as DateTime?;
  String get _timeSlot => reservationData['timeSlot'] as String? ?? '';
  String get _tableId => reservationData['tableId']?.toString() ?? '';
  int get _guestCount => (reservationData['guestCount'] as num?)?.toInt() ?? 0;
  num get _orderTotal => reservationData['orderTotal'] as num? ?? 0;
  List<Map<String, dynamic>> get _cartItems {
    final value = reservationData['cartItems'];
    if (value is List<Map<String, dynamic>>) {
      return value;
    }
    if (value is List) {
      return value.whereType<Map<String, dynamic>>().toList();
    }
    return const [];
  }

  String get _formattedDate {
    final date = _reservationDate;
    if (date == null) {
      return '';
    }
    return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
  }

  void _popToClubDetail(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      if (route.settings.name == clubDetailRouteName) {
        return true;
      }
      // 안전장치: 지정 라우트를 못 찾으면 루트에서 멈춤
      return route.isFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tableText = _tableId.isNotEmpty ? '$_tableId번 테이블' : '';
    final guestText = _guestCount > 0 ? '$_guestCount명' : '';
    final tableAndGuest = [
      if (tableText.isNotEmpty) tableText,
      if (guestText.isNotEmpty) guestText,
    ].join(' · ');
    final dateAndTime = [
      if (_formattedDate.isNotEmpty) _formattedDate,
      if (_timeSlot.isNotEmpty) _timeSlot,
    ].join(' ');
    final formattedTotal = _priceFormatter.format(_orderTotal);

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
          '결제완료',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                width: 80.w,
                height: 80.w,
                'assets/icons/table_reservation_page/success_icon.svg',
              ),
              SizedBox(height: 60.h),
              Text(
                '테이블 예약이 완료되었습니다!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.08,
                  letterSpacing: -0.60,
                ),
              ),
              SizedBox(height: 24.h),
              if (_clubName.isNotEmpty)
                Text(
                  _clubName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACB) /* Gray400 */,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              if (dateAndTime.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(
                  dateAndTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACB) /* Gray400 */,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              ],
              if (tableAndGuest.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Text(
                  tableAndGuest,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFFCACACB) /* Gray400 */,
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.12,
                    letterSpacing: -0.80,
                  ),
                ),
              ],
              SizedBox(height: 24.h),

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(color: Color(0xFF2F2F33)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '결제 내역',
                          style: TextStyle(
                            color: const Color(0xFFECECEC) /* Gray200 */,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                            letterSpacing: -0.80,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 12.w,
                          ),
                          decoration: BoxDecoration(color: Color(0xFF404042)),
                          child: Row(
                            children: [
                              Text(
                                '총 결제 금액',
                                style: TextStyle(
                                  color: const Color(0xFFECECEC) /* Gray200 */,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.14,
                                  letterSpacing: -0.35,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '$formattedTotal원',
                                style: TextStyle(
                                  color: Colors.white /* White */,
                                  fontSize: 16,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w600,
                                  height: 1.25,
                                  letterSpacing: -0.80,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        ..._cartItems.map((item) {
                          final String name = item['name']?.toString() ?? '메뉴';
                          final int qty =
                              (item['quantity'] as num?)?.toInt() ?? 0;
                          final String label = qty > 0 ? '$name x$qty' : name;
                          final num itemPrice = item['totalPrice'] as num? ?? 0;
                          final String optionsText =
                              (item['options'] as List?)
                                  ?.whereType<String>()
                                  .where((e) => e.trim().isNotEmpty)
                                  .join(', ') ??
                              '';

                          return Padding(
                            padding: EdgeInsets.only(
                              left: 12.w,
                              right: 12.w,
                              top: 4.h,
                              bottom: 4.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          color: const Color(
                                            0xFFCACACB,
                                          ) /* Gray400 */,
                                          fontSize: 12,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                          height: 1.17,
                                          letterSpacing: -0.30,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${_priceFormatter.format(itemPrice)}원',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFFCACACB,
                                        ) /* Gray400 */,
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                        height: 1.17,
                                        letterSpacing: -0.30,
                                      ),
                                    ),
                                  ],
                                ),
                                if (optionsText.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    optionsText,
                                    style: TextStyle(
                                      color: const Color(0xFF8E8E90),
                                      fontSize: 11,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                      height: 1.17,
                                      letterSpacing: -0.30,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: -(12.w),
                    child: SizedBox(
                      height: 24.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            18,
                            (_) => SizedBox(
                              width: 12.w,
                              height: 12.w,
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  color: AppColors.appBackgroundColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 44.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
          child: SizedBox(
            height: 40.h,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appPurpleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              onPressed: () => _popToClubDetail(context),
              child: Text(
                '확인',
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
    );
  }
}
