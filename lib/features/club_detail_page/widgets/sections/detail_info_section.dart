import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';

class DetailInfoSection extends StatelessWidget {
  const DetailInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상세 정보', style: AppTextStyles.sectionTitle),
          SizedBox(height: 24.h),
          _buildInfoItem(
            '전화번호',
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/club_detail/phone.svg',
                  width: 16.w,
                  height: 16.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  clubData['phoneNumber']! as String,
                  style: AppTextStyles.body.copyWith(
                    color: const Color(0xFFCACACB),
                  ),
                ),
              ],
            ),
          ),
          _buildInfoItem(
            '안내 및 유의사항',
            Text(
              clubData['guidelines']! as String,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xFFCACACB),
              ),
            ),
          ),
          _buildInfoItem(
            '영업 시간',
            Text(
              clubData['businessHoursSummary']! as String,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xFFD1C9C9),
              ),
            ),
          ),
          _buildInfoItem(
            '오픈 채팅',
            Text(
              clubData['openChatLink']! as String,
              style: AppTextStyles.link,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, Widget content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body.copyWith(color: const Color(0xFFCACACB)),
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }
}
