import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/widgets/custom_divider.dart';
import 'package:vybe/features/table_reservation_page/models/cart_entry.dart';
import 'package:vybe/features/table_reservation_page/screens/payment_success_page.dart';
import 'package:vybe/features/table_reservation_page/screens/select_options_page.dart';
import 'package:vybe/features/table_reservation_page/widgets/cart_items_list_view.dart';
import 'package:vybe/features/table_reservation_page/widgets/purchase_page/purchase_agreement_section.dart';
import 'package:vybe/features/table_reservation_page/widgets/purchase_page/payment_method_grid.dart';
import 'package:vybe/features/table_reservation_page/widgets/purchase_page/reservation_info_section.dart';

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
  String? _selectedCardIssuer;
  String? _selectedInstallmentPlan;
  final List<AgreementItem> _agreementItems = const [
    AgreementItem(
      id: 'confirm_notice',
      title: '위 사항을 확인하였으며 구매 진행에 동의합니다.',
      isRequired: true,
    ),
    AgreementItem(id: 'terms_of_use', title: '이용 약관에 동의합니다.', isRequired: true),
    AgreementItem(id: 'privacy', title: '개인 정보 수집에 동의합니다.', isRequired: true),
    AgreementItem(
      id: 'future_payment',
      title: '이 결제 수단으로 추후 결제 이용에 동의합니다.',
      isRequired: false,
    ),
  ];

  /// 사용자가 체크한 동의 항목 id를 저장한다.
  final Set<String> _checkedAgreementIds = <String>{};

  static const List<List<PaymentMethodOption>> _paymentMethodRows = [
    [
      PaymentMethodOption(
        id: 'credit_card_primary',
        displayName: '신용카드',
        label: '신용카드',
      ),
      PaymentMethodOption(
        id: 'kakao_pay',
        displayName: '카카오페이',
        assetPath: 'assets/images/purchase_page/kakaoPay.png',
      ),
      PaymentMethodOption(
        id: 'naver_pay',
        displayName: '네이버페이',
        assetPath: 'assets/images/purchase_page/naverPay.png',
      ),
    ],
    [
      PaymentMethodOption(
        id: 'toss_pay',
        displayName: '토스페이',
        assetPath: 'assets/images/purchase_page/tossPay.png',
        wrapAsset: true,
      ),
      PaymentMethodOption(
        id: 'payco',
        displayName: '페이코',
        assetPath: 'assets/images/purchase_page/payco.png',
      ),
      PaymentMethodOption(
        id: 'credit_card_secondary',
        displayName: '신용카드',
        label: '신용카드',
      ),
    ],
    [
      PaymentMethodOption(
        id: 'mobile_payment',
        displayName: '휴대폰 결제',
        label: '휴대폰 결제',
      ),
      PaymentMethodOption(
        id: 'bank_transfer',
        displayName: '무통장 입금',
        label: '무통장 입금',
      ),
      PaymentMethodOption(id: 'gift_card', displayName: '상품권', label: '상품권'),
    ],
  ];

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
  int get _guestCount => (_reservation['guestCount'] as num?)?.toInt() ?? 0;

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

  bool get _isAllAgreed =>
      _agreementItems.isNotEmpty &&
      _checkedAgreementIds.length == _agreementItems.length;

  bool get _hasAgreedRequired => _agreementItems.every(
    (item) => !item.isRequired || _checkedAgreementIds.contains(item.id),
  );

  num _parsePrice(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// id로 특정 동의 항목 체크 상태를 토글한다.
  void _toggleAgreement(String id) {
    setState(() {
      if (!_checkedAgreementIds.add(id)) {
        _checkedAgreementIds.remove(id);
      }
    });
  }

  /// 모든 동의 항목을 한 번에 선택/해제한다.
  void _toggleAllAgreements(bool nextValue) {
    setState(() {
      if (nextValue) {
        _checkedAgreementIds
          ..clear()
          ..addAll(_agreementItems.map((item) => item.id));
      } else {
        _checkedAgreementIds.clear();
      }
    });
  }

  /// 옵션 선택 화면을 열고 결과를 장바구니 항목에 반영한다.
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

    final rawCartItems = _reservation['cartItems'];
    Set<CartEntry>? cartItems;
    bool shouldAssignCartItems = false;
    if (rawCartItems is Set<CartEntry>) {
      cartItems = rawCartItems;
    } else if (rawCartItems is Iterable<CartEntry>) {
      cartItems = rawCartItems.toSet();
      shouldAssignCartItems = true;
    }

    if (cartItems == null) {
      return;
    }

    final payload = Map<String, dynamic>.from(result);
    final int nextQuantityRaw = payload['quantity'] as int? ?? entry.quantity;
    final int nextQuantity = nextQuantityRaw < 1 ? 1 : nextQuantityRaw;
    final List<Map<String, dynamic>> selectedOptions =
        (payload['options'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((opt) => Map<String, dynamic>.from(opt))
            .toList() ??
        <Map<String, dynamic>>[];
    final num basePrice = _parsePrice(entry.menu['price']);
    final num optionsExtra = selectedOptions.fold<num>(
      0,
      (sum, opt) => sum + _parsePrice(opt['price']),
    );
    final num resultTotal =
        payload['totalPrice'] as num? ??
        (basePrice * nextQuantity + optionsExtra);
    final num nextUnitPrice = nextQuantity > 0
        ? resultTotal / nextQuantity
        : basePrice + optionsExtra;

    setState(() {
      if (shouldAssignCartItems) {
        _reservation['cartItems'] = cartItems!;
      }
      final updatedEntry = entry.copyWith(
        options: selectedOptions,
        quantity: nextQuantity,
        unitPrice: nextUnitPrice,
      );
      cartItems!.remove(entry);
      final existing = cartItems.lookup(updatedEntry);
      if (existing != null) {
        existing.quantity += updatedEntry.quantity;
      } else {
        cartItems.add(updatedEntry);
      }
    });
  }

  /// 장바구니 항목의 수량을 1 이상으로 조정한다.
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

  /// 섹션 제목을 동일한 스타일로 렌더링한다.
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

  /// 예약 정보를 라벨/값 형태로 한 줄에 보여준다.
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

  /// 장바구니 항목 한 줄 요약을 렌더링한다.
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

  @override
  /// 위젯 트리를 그린다.
  Widget build(BuildContext context) {
    final formattedDate = _reservationDate != null
        ? DateFormat('MM월 dd일 (E)', 'ko_KR').format(_reservationDate!)
        : '-';
    final totalPrice = _priceFormatter.format(orderTotal);
    final bool canProceedPayment = _hasAgreedRequired && cartItems.isNotEmpty;
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
            fontSize: 20.sp,
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
                  ReservationInfoSection(
                    items: buildReservationInfoItems(
                      name: _reservationName,
                      contact: _contactNumber,
                      dateText: formattedDate,
                      timeSlot: _timeSlot,
                      tableId: _tableId,
                    ),
                  ),
                ],
              ),
            ),
            const CustomDivider(),
            Container(
              padding: EdgeInsets.all(24.w),
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
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSectionTitle('결제 금액'),
                  Text(
                    '${_priceFormatter.format(orderTotal)}원',
                    style: TextStyle(
                      color: Colors.white /* White */,
                      fontSize: 24.sp,
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
                                fontSize: 12.sp,
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
                                          fontSize: 12.sp,
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
                                        fontSize: 12.sp,
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
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '결제 수단 선택',
                    style: TextStyle(
                      color: const Color(0xFFECECEC) /* Gray200 */,
                      fontSize: 15.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  PaymentMethodGrid(
                    rows: _paymentMethodRows,
                    selectedId: _selectedPaymentMethodId,
                    onSelect: (option) {
                      setState(() {
                        _selectedPaymentMethodId = option.id;
                        _selectedPaymentMethodName = option.displayName;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  if (_selectedPaymentMethodId == "credit_card_primary") ...[
                    GestureDetector(
                      onTap: () async {
                        final selectedBank = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            final List<String> banks = [
                              '신한',
                              '현대',
                              '비씨',
                              'KB국민',
                              '삼성',
                              '롯데',
                              '하나',
                              'NH',
                              '우리',
                              '광주',
                              '씨티',
                              '전북',
                              '카카오뱅크',
                              '케이뱅크',
                            ];
                            return FractionallySizedBox(
                              heightFactor: 0.65,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 32.h,
                                  left: 20.w,
                                  right: 20.w,
                                  bottom:
                                      24.h +
                                      MediaQuery.of(context).padding.bottom,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F2F33),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24.r),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '결제를 위한 카드를 선택해주세요.',
                                      style: TextStyle(
                                        color: Colors.white /* White */,
                                        fontSize: 20.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Expanded(
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: banks.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 8.h),
                                        itemBuilder: (context, index) {
                                          final bankName = banks[index];

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context, bankName);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                              ),
                                              child: Text(
                                                bankName,
                                                style: TextStyle(
                                                  color:
                                                      _selectedCardIssuer ==
                                                          bankName
                                                      ? AppColors.appGreenColor
                                                      : const Color(0xFFECECEC),
                                                  fontSize: 20.sp,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        if (selectedBank != null) {
                          setState(() {
                            _selectedCardIssuer = selectedBank;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.w,
                            color: Color(0xFF2F2F33),
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _selectedCardIssuer ?? '카드사를 선택해주세요.',
                              style: TextStyle(
                                color: _selectedCardIssuer == null
                                    ? const Color(0xFFCACACB) /* Gray400 */
                                    : AppColors.appGreenColor,
                                fontSize: 14.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 1.14,
                                letterSpacing: -0.70,
                              ),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              'assets/icons/common/arrow_down.svg',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: () async {
                        final selectedPlan = await showModalBottomSheet<String>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            final List<String> plans = [
                              '일시불',
                              '2개월 (무이자)',
                              '3개월 (무이자)',
                              '4개월',
                              '5개월',
                              '6개월',
                              '7개월',
                              '8개월',
                              '9개월',
                              '10개월',
                            ];
                            return FractionallySizedBox(
                              heightFactor: 0.75,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                  top: 32.h,
                                  left: 20.w,
                                  right: 20.w,
                                  bottom:
                                      24.h +
                                      MediaQuery.of(context).padding.bottom,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F2F33),
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24.r),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '결제 방법을 선택해주세요.',
                                      style: TextStyle(
                                        color: Colors.white /* White */,
                                        fontSize: 20.sp,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 24.h),
                                    Expanded(
                                      child: ListView.separated(
                                        padding: EdgeInsets.zero,
                                        itemCount: plans.length,
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 8.h),
                                        itemBuilder: (context, index) {
                                          final plan = plans[index];

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context, plan);
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 12.h,
                                              ),
                                              child: Text(
                                                plan,
                                                style: TextStyle(
                                                  color:
                                                      _selectedInstallmentPlan ==
                                                          plan
                                                      ? AppColors.appGreenColor
                                                      : const Color(0xFFECECEC),
                                                  fontSize: 20.sp,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        if (selectedPlan != null) {
                          setState(() {
                            _selectedInstallmentPlan = selectedPlan;
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.w,
                            color: Color(0xFF2F2F33),
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _selectedInstallmentPlan ?? '결제 방법을 선택해주세요.',
                              style: TextStyle(
                                color: const Color(0xFFCACACB) /* Gray400 */,
                                fontSize: 14.sp,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                                height: 1.14,
                                letterSpacing: -0.70,
                              ),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              'assets/icons/common/arrow_down.svg',
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '※ 50,000원 이상 무이자 할부 3개월',
                      style: TextStyle(
                        color: const Color(0xFFCACACB) /* Gray400 */,
                        fontSize: 12.sp,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 1.17,
                        letterSpacing: -0.30,
                      ),
                    ),
                  ],

                  SizedBox(height: 24.h),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PurchaseAgreementSection(
                    items: _agreementItems,
                    checkedIds: _checkedAgreementIds,
                    onToggleItem: _toggleAgreement,
                    onToggleAll: _toggleAllAgreements,
                  ),
                  SizedBox(height: 24.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) {
                            return PaymentSuccessPage(
                              reservationData: {
                                'clubNㄴame': _clubName,
                                'reservationDate': _reservationDate,
                                'timeSlot': _timeSlot,
                                'tableId': _tableId,
                                'guestCount': _guestCount,
                              },
                            );
                          },
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: canProceedPayment
                            ? AppColors.appPurpleColor
                            : const Color(0xFF2F1A5A),
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
                  SizedBox(height: 37.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
