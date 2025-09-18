import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vybe/core/app_text_style.dart';

class CallButton extends StatelessWidget {
  const CallButton({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('전화 앱을 열 수 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _makePhoneCall('010 5909195'),
      child: Container(
        width: 60.w,
        height: 26.h,
        decoration: BoxDecoration(
          border: Border.all(width: 1.w, color: const Color(0xFF9F9FA1)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('assets/icons/club_detail/call.svg', width: 14.w),
            Text("전화", style: AppTextStyles.callButtonText),
          ],
        ),
      ),
    );
  }
}
