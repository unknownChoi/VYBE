import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/core/app_text_style.dart';

class PhotoTab extends StatefulWidget {
  final GlobalKey? topKey;
  const PhotoTab({super.key, this.topKey});

  @override
  State<PhotoTab> createState() => _PhotoTabState();
}

class _PhotoTabState extends State<PhotoTab>
    with AutomaticKeepAliveClientMixin<PhotoTab> {
  bool _isExpanded = false;
  final int _initialPhotoCount = 6;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final photosToShow =
        _isExpanded
            ? photoTabImageList
            : photoTabImageList.take(_initialPhotoCount).toList();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          if (widget.topKey != null) SizedBox.shrink(key: widget.topKey),
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // TODO: Photo viewer
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.asset(photosToShow[index], fit: BoxFit.cover),
                ),
              );
            },
            itemCount: photosToShow.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          if (photoTabImageList.length > _initialPhotoCount && !_isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: GestureDetector(
                onTap: () => setState(() => _isExpanded = true),
                child: Container(
                  height: 56.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF404042)),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      '사진 더보기',
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
