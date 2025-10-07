import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/features/bottom_nav_search/widgets/keyword_skeleton_chip.dart';

class KeywordSection extends StatelessWidget {
  const KeywordSection({
    super.key,
    required this.title,
    required this.future,
    required this.titleStyle,
    required this.emptyMessage,
    required this.chipBuilder,
    this.trailing,
  });

  final String title;
  final Future<List<String>> future;
  final TextStyle titleStyle;
  final String emptyMessage;
  final Widget Function(String keyword) chipBuilder;
  final Widget? trailing;

  static const int _skeletonItemCount = 6;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: titleStyle),
            if (trailing != null) ...[const Spacer(), trailing!],
          ],
        ),
        SizedBox(height: 24.h),
        FutureBuilder<List<String>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return _buildChipWrap(
                List.generate(
                  _skeletonItemCount,
                  (_) => const KeywordSkeletonChip(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text(
                '불러오기에 실패했습니다.',
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              );
            }

            final data = snapshot.data ?? const <String>[];
            if (data.isEmpty) {
              return Text(
                emptyMessage,
                style: TextStyle(
                  color: const Color(0xFFCACACB),
                  fontSize: 14.sp,
                ),
              );
            }

            return _buildChipWrap(data.map(chipBuilder).toList());
          },
        ),
      ],
    );
  }

  Widget _buildChipWrap(List<Widget> children) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(spacing: 8.w, runSpacing: 8.h, children: children),
    );
  }
}
