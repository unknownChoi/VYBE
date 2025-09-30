import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vybe/data/club_detail_mock_data.dart';
import 'package:vybe/core/widgets/custom_divider.dart';
import 'package:vybe/features/club_detail_page/widgets/sections/detail_info_section.dart';

import 'package:vybe/features/club_detail_page/widgets/sections/location_section.dart';

class ClubInfoTab extends StatefulWidget {
  const ClubInfoTab({super.key});

  @override
  State<ClubInfoTab> createState() => _ClubInfoTabState();
}

class _ClubInfoTabState extends State<ClubInfoTab>
    with AutomaticKeepAliveClientMixin<ClubInfoTab> {
  NaverMapController? _mapController;
  NMarker? _marker;
  late final NCameraPosition _initialCameraPosition;

  @override
  void initState() {
    super.initState();
    final coords = clubData['addressCoords'] as Map<String, double>;
    final position = NLatLng(coords['x']!, coords['y']!);

    _initialCameraPosition = NCameraPosition(
      target: position,
      zoom: 16,
      bearing: 0,
      tilt: 0,
    );

    _loadMarker(position);
  }

  void _loadMarker(NLatLng position) async {
    final icon = NOverlayImage.fromAssetImage(
      'assets/images/common/map_location_pin.png',
    );

    _marker = NMarker(
      id: 'my-marker',
      position: position,
      icon: icon,
      size: NSize(20.w, 22.w),
    );

    if (_mapController != null) {
      _mapController!.addOverlay(_marker!);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final subwayInfo = clubData['subwayInfo'] as Map<String, dynamic>;
    final line = subwayInfo['line'] as String;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocationSection(
            initialCameraPosition: _initialCameraPosition,
            marker: _marker,
            onMapReady: (controller) {
              _mapController = controller;
              if (_marker != null) {
                _mapController!.addOverlay(_marker!);
              }
            },
            subwayInfo: subwayInfo,
            line: line,
          ),
          const CustomDivider(),
          const DetailInfoSection(),
        ],
      ),
    );
  }
}
