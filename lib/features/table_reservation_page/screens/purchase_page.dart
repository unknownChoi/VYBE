import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/widgets/custom_divider.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/screens/select_options_page.dart';
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
  String? _selectedPaymentMethodId;
  String? _selectedPaymentMethodName;

  Map<String, dynamic> get _reservation => widget.reservationData.isNotEmpty
      ? widget.reservationData.first
      : const <String, dynamic>{};

  String get _clubName => _reservation['clubName'] as String? ?? '';
  String get _reservationName =>
      _reservation['reservationName'] as String? ?? '';
  String get _contactNumber => _reservation['contactNumber'] as String? ?? '';
  DateTime? get _reservationDate =>
      _reservation['reservationDate'] as DateTime?;
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

  Future<void> _onChangeOptions(CartEntry entry) async {
    final menuOptions = entry.menu['options'];
    if (menuOptions is! List || menuOptions.isEmpty) {
      return;
    }

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => SelectOptionsPage(
          menu: Map<String, dynamic>.from(entry.menu),
          options: menuOptions,
          initialSelectedOptions: entry.options
              .map((opt) => Map<String, dynamic>.from(opt))
              .toList(),
          initialQuantity: entry.quantity,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }
  }

  void _updateQuantity(CartEntry entry, int delta) {
    final next = entry.quantity + delta;
    if (next < 1) {
      return;
    }
    setState(() {
      entry.quantity = next;
    });
  }

  List<CartEntry> get cartItems => _cartItemSet.toList();

  num get orderTotal =>
      _cartItemSet.fold<num>(0, (sum, item) => sum + item.totalPrice);

  Widget buildSectionTitle(String title) {
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

  Widget buildInfoRow({required String label, required String value}) {
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

  Widget buildMenuItem(CartEntry entry) {
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

  Widget _buildPaymentOption({
    required String id,
    required String displayName,
    String? label,
    String? assetPath,
    bool wrapAsset = false,
  }) {
    Widget child;
    if (assetPath != null) {
      final image = Image.asset(assetPath);
      child = wrapAsset
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: image,
            )
          : image;
    } else if (label != null) {
      child = Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFFECECEC) /* Purple300 */,
          fontSize: 16,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
          height: 1.12,
          letterSpacing: -0.80,
        ),
      );
    } else {
      child = const SizedBox();
    }

    final isSelected = _selectedPaymentMethodId == id;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6.r),
          onTap: () {
            setState(() {
              _selectedPaymentMethodId = id;
              _selectedPaymentMethodName = displayName;
            });
          },
          child: Container(
            height: 68.h,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF2F1A5A) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(
                width: 1,
                color: isSelected
                    ? const Color(0xFF7731FE)
                    : const Color(0xFF2F2F33),
              ),
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentRow(List<Widget> options) {
    return Row(
      children: [
        for (int i = 0; i < options.length; i++) ...[
          options[i],
          if (i < options.length - 1) SizedBox(width: 4.w),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _reservationDate != null
        ? DateFormat('MM월 dd일 (E)', 'ko_KR').format(_reservationDate!)
        : '-';
    final totalPrice = _priceFormatter.format(orderTotal);
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
        child: Column(
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cartItems.isEmpty)
                    Center(
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
                  else
                    CartItemsListView(
                      entries: cartItems,
                      onChangeOptions: _onChangeOptions,
                      onUpdateQuantity: _updateQuantity,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                ],
              ),
            ),
            const CustomDivider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('결제 금액'),
                  Text(
                    '${_priceFormatter.format(orderTotal)}원',
                    style: TextStyle(
                      color: Colors.white /* White */,
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      height: 1.08,
                      letterSpacing: -0.60,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: Color(0xFF2F2F33)),
                        bottom: BorderSide(width: 1, color: Color(0xFF2F2F33)),
                      ),
                    ),
                    child: Column(
                      children: [
                        if (cartItems.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Text(
                              '결제할 내역이 없습니다.',
                              style: TextStyle(
                                color: const Color(0xFFCACACB) /* Gray400 */,
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                                height: 1.17,
                                letterSpacing: -0.30,
                              ),
                            ),
                          )
                        else
                          ...List.generate(cartItems.length, (index) {
                            final entry = cartItems[index];
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.menuName,
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
                                      '${_priceFormatter.format(entry.totalPrice)}원',
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
                                if (index < cartItems.length - 1)
                                  SizedBox(height: 8.h),
                              ],
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const CustomDivider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '결제 수단 선택',
                    style: TextStyle(
                      color: const Color(0xFFECECEC) /* Gray200 */,
                      fontSize: 15,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildPaymentRow([
                    _buildPaymentOption(
                      id: 'credit_card_primary',
                      displayName: '신용카드',
                      label: '신용카드',
                    ),
                    _buildPaymentOption(
                      id: 'kakao_pay',
                      displayName: '카카오페이',
                      assetPath: 'assets/images/purchase_page/kakaoPay.png',
                    ),
                    _buildPaymentOption(
                      id: 'naver_pay',
                      displayName: '네이버페이',
                      assetPath: 'assets/images/purchase_page/naverPay.png',
                    ),
                  ]),
                  SizedBox(height: 4.h),
                  _buildPaymentRow([
                    _buildPaymentOption(
                      id: 'toss_pay',
                      displayName: '토스페이',
                      assetPath: 'assets/images/purchase_page/tossPay.png',
                      wrapAsset: true,
                    ),
                    _buildPaymentOption(
                      id: 'payco',
                      displayName: '페이코',
                      assetPath: 'assets/images/purchase_page/payco.png',
                    ),
                    _buildPaymentOption(
                      id: 'credit_card_secondary',
                      displayName: '신용카드',
                      label: '신용카드',
                    ),
                  ]),
                  SizedBox(height: 4.h),
                  _buildPaymentRow([
                    _buildPaymentOption(
                      id: 'mobile_payment',
                      displayName: '휴대폰 결제',
                      label: '휴대폰 결제',
                    ),
                    _buildPaymentOption(
                      id: 'bank_transfer',
                      displayName: '무통장 입금',
                      label: '무통장 입금',
                    ),
                    _buildPaymentOption(
                      id: 'gift_card',
                      displayName: '상품권',
                      label: '상품권',
                    ),
                  ]),
                  SizedBox(height: 16.h),
                  if (_selectedPaymentMethodName == "신용카드") ...[
                    SizedBox(
                      width: double.infinity,

                      child: DropdownButtonFormField<String>(
                        initialValue: null,
                        items: const [
                          DropdownMenuItem(
                            value: 'shinhan',
                            child: SizedBox(
                              width: double.infinity, // ← 아이템 창이 필드 폭을 따르게
                              child: Text(
                                '신한카드',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'hyundai',
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '현대카드',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'kb',
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                '국민카드',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        dropdownColor: const Color(0xFF1B1B1D),
                        isExpanded: true,
                        onChanged: (v) {},
                        hint: Text(
                          '카드사를 선택해주세요.',
                          style: TextStyle(
                            color: const Color(0xFFCACACB) /* Gray400 */,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.14,
                            letterSpacing: -0.70,
                          ),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.appBackgroundColor,
                          contentPadding: EdgeInsets.all(12.w),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              width: 1.w,
                              color: Color(0xFF2F2F33),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              width: 1.w,
                              color: Color(0xFF2F2F33),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                  Container(
                    width: double.infinity,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: AppColors.appPurpleColor,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
