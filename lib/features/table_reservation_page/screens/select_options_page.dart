import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/core/app_colors.dart';
import 'package:vybe/core/app_text_style.dart';

class SelectOptionsPage extends StatefulWidget {
  final Map<String, dynamic> menu;
  final List<dynamic> options;

  const SelectOptionsPage({
    super.key,
    required this.menu,
    required this.options,
  });

  @override
  State<SelectOptionsPage> createState() => _SelectOptionsPageState();
}

class _SelectOptionsPageState extends State<SelectOptionsPage> {
  List<Map<String, dynamic>> get _optionGroups =>
      widget.options.whereType<Map<String, dynamic>>().toList();

  @override
  Widget build(BuildContext context) {
    final menuName = widget.menu['name'] as String? ?? '메뉴';
    final optionGroups = _optionGroups;

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
            Navigator.pop(context, false);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          '$menuName 옵션 선택',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: optionGroups.isEmpty
            ? Center(
                child: Text(
                  '등록된 옵션이 없습니다.',
                  style: AppTextStyles.subtitle,
                ),
              )
            : ListView.separated(
                itemCount: optionGroups.length,
                itemBuilder: (context, index) {
                  final option = optionGroups[index];
                  final title = option['title'] as String? ?? '옵션';
                  final items = (option['items'] as List?)
                          ?.whereType<Map<String, dynamic>>()
                          .toList() ??
                      const [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.sectionTitle),
                      SizedBox(height: 12.h),
                      if (items.isEmpty)
                        Text(
                          '선택 가능한 항목이 없습니다.',
                          style: AppTextStyles.subtitle,
                        )
                      else
                        ...items.map((item) {
                          final label = item['label'] as String? ?? '옵션';
                          final price = item['price'];
                          final hasPrice = price is num;
                          final displayPrice =
                              hasPrice ? '+${price.toInt()}원' : '';
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Text(
                              displayPrice.isNotEmpty
                                  ? '$label ($displayPrice)'
                                  : label,
                              style: AppTextStyles.body,
                            ),
                          );
                        }),
                    ],
                  );
                },
                separatorBuilder: (_, __) => SizedBox(height: 24.h),
              ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
          child: SizedBox(
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appPurpleColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                '선택 완료',
                style: AppTextStyles.actionButton,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
