import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_text_style.dart';
import 'package:vybe/data/club_detail_mock_data.dart';

class ClubSignatureSection extends StatefulWidget {
  final VoidCallback? onSeeAll;
  const ClubSignatureSection({super.key, this.onSeeAll});

  @override
  State<ClubSignatureSection> createState() => _ClubSignatureSectionState();
}

class _ClubSignatureSectionState extends State<ClubSignatureSection> {
  late final List<Map<String, dynamic>> _mainMenuItems;

  @override
  void initState() {
    super.initState();
    _mainMenuItems = menuItemsData.values
        .expand((menuList) => menuList)
        .where((item) => item['isMain'] as bool)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final mainMenuItems = _mainMenuItems;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("메뉴", style: AppTextStyles.sectionTitle),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("전체보기", style: AppTextStyles.seeAll),
                  SizedBox(width: 4.w),
                  SvgPicture.asset('assets/icons/club_detail/arrow_right.svg'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(thickness: 1.h, color: const Color(0xFF404042)),
        ...mainMenuItems.expand(
          (item) => [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: MenuItemCard(
                menuName: item['name'] as String,
                menuPrice: item['price'] as int,
                menuImageSrc: item['image'] as String,
                isMainMenu: item['isMain'] as bool,
              ),
            ),
            Divider(thickness: 1.h, color: const Color(0xFF404042)),
          ],
        ),
        Text(
          '메뉴 항목과 가격은 각 매장 사정에 따라 기재된 내용과 다를 수 있습니다.',
          style: TextStyle(
            color: const Color(0xFF9F9FA1),
            fontSize: 12.sp,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w400,
            height: 1.17.h,
            letterSpacing: -0.30.w,
          ),
        ),
      ],
    );
  }
}
