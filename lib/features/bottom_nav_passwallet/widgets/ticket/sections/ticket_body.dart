import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/features/bottom_nav_passwallet/models/passwallet_models.dart';

class TicketBody extends StatelessWidget {
  const TicketBody({
    super.key,
    required this.status,
    required this.count,
    required this.entryTimeText,
    this.currentNum,
    this.reservationTable,
  });

  final PassStatus status;
  final int count;
  final int? currentNum;
  final String? reservationTable;
  final String entryTimeText;

  TextStyle get _summaryLabel =>
      AppTextStyles.businessHours.copyWith(color: const Color(0xFFECECEC));

  TextStyle get _summaryValue => AppTextStyles.teamSuffixTextStyle.copyWith(
    color: const Color(0xFFECECEC),
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    height: 1.10,
    letterSpacing: (-0.50).w,
  );

  TextStyle get _highlightLarge => AppTextStyles.teamCountTextStyle.copyWith(
    color: const Color(0xFFB5FF60),
    fontSize: 44.sp,
    fontWeight: FontWeight.w700,
    height: 1.18,
    letterSpacing: (-1.10).w,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 200.h,
      color: const Color(0xFF2F2F33),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildHeadline(), _buildSummary()],
      ),
    );
  }

  Widget _buildHeadline() {
    switch (status) {
      case PassStatus.waiting:
        return Column(
          children: [
            Text(
              '현재 대기 번호',
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              '${currentNum ?? '-'}번',
              textAlign: TextAlign.center,
              style: _highlightLarge,
            ),
            SizedBox(height: 18.h),
          ],
        );
      case PassStatus.entered:
        return Column(
          children: [
            Text(
              '입장완료',
              textAlign: TextAlign.center,
              style: _highlightLarge.copyWith(fontSize: 32.sp),
            ),
            SizedBox(height: 18.h),
          ],
        );
      case PassStatus.entering:
        return Column(
          children: [
            Text(
              '현재 대기 번호',
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text('입장', textAlign: TextAlign.center, style: _highlightLarge),
            SizedBox(height: 18.h),
          ],
        );
      case PassStatus.reservation:
        return Column(
          children: [
            Text(
              '예약 상태',
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
            SizedBox(height: 8.h),
            Text(
              '예약완료',
              textAlign: TextAlign.center,
              style: _highlightLarge.copyWith(fontSize: 28.sp),
            ),
            SizedBox(height: 18.h),
          ],
        );
    }
  }

  Widget _dividerV() =>
      Container(width: 1.5.w, height: 40.h, color: const Color(0xFF707071));

  Widget _buildSummary() {
    switch (status) {
      case PassStatus.entered:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 118.w,
                  child: Column(
                    children: [
                      Text(
                        '대기 시간',
                        textAlign: TextAlign.center,
                        style: _summaryLabel,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '-', // entering이 아니므로 기존 로직 유지
                        textAlign: TextAlign.center,
                        style: _summaryValue,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25.w),
                _dividerV(),
                SizedBox(width: 25.w),
                SizedBox(
                  width: 118.w,
                  child: Column(
                    children: [
                      Text(
                        '인원',
                        textAlign: TextAlign.center,
                        style: _summaryLabel,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '$count명',
                        textAlign: TextAlign.center,
                        style: _summaryValue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Container(
              width: 286.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFF535355),
                borderRadius: BorderRadius.circular(6.r),
              ),
              alignment: Alignment.center,
              child: Text(
                '후기 작성하러 가기',
                textAlign: TextAlign.center,
                style: AppTextStyles.actionButton,
              ),
            ),
          ],
        );

      case PassStatus.reservation:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '좌석 정보',
                      textAlign: TextAlign.center,
                      style: _summaryLabel,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      reservationTable ?? '-',
                      textAlign: TextAlign.center,
                      style: _summaryValue,
                    ),
                  ],
                ),
                SizedBox(width: 25.w),
                _dividerV(),
                SizedBox(width: 25.w),
                Column(
                  children: [
                    Text(
                      '결제 정보',
                      textAlign: TextAlign.center,
                      style: _summaryLabel,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '완료',
                      textAlign: TextAlign.center,
                      style: _summaryValue,
                    ),
                  ],
                ),
                SizedBox(width: 25.w),
                _dividerV(),
                SizedBox(width: 25.w),
                Column(
                  children: [
                    Text(
                      '인원',
                      textAlign: TextAlign.center,
                      style: _summaryLabel,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      '$count명',
                      textAlign: TextAlign.center,
                      style: _summaryValue,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
          ],
        );

      case PassStatus.waiting:
      case PassStatus.entering:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  '남은 시간',
                  textAlign: TextAlign.center,
                  style: _summaryLabel,
                ),
                SizedBox(height: 10.h),
                Text(
                  status == PassStatus.entering ? entryTimeText : "-",
                  textAlign: TextAlign.center,
                  style: _summaryValue,
                ),
              ],
            ),
            SizedBox(width: 25.w),
            _dividerV(),
            SizedBox(width: 25.w),
            Column(
              children: [
                Text(
                  '남은 거리',
                  textAlign: TextAlign.center,
                  style: _summaryLabel,
                ),
                SizedBox(height: 10.h),
                Text('999m', textAlign: TextAlign.center, style: _summaryValue),
              ],
            ),
            SizedBox(width: 25.w),
            _dividerV(),
            SizedBox(width: 25.w),
            Column(
              children: [
                Text('인원', textAlign: TextAlign.center, style: _summaryLabel),
                SizedBox(height: 10.h),
                Text(
                  '$count명',
                  textAlign: TextAlign.center,
                  style: _summaryValue,
                ),
              ],
            ),
          ],
        );
    }
  }
}
