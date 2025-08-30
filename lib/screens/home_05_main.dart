import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vybe/constants/appcolors.dart';
import 'package:vybe/screens/auth/login_1_main.dart';
import 'package:vybe/services/firebase/firebase_service.dart';

// 스타일 상수 분리
const TextStyle bottomNavSelectedLabelStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  height: 1.17,
  letterSpacing: -0.30,
);

const TextStyle bottomNavUnselectedLabelStyle = TextStyle(
  color: AppColors.appGreenColor,
  fontSize: 12,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  height: 1.17,
  letterSpacing: -0.30,
);

class FeatureItem {
  final String iconPath;
  final String label;
  const FeatureItem({required this.iconPath, required this.label});
}

// BottomNavigationBar 아이콘 + 라벨 간격, 색상 처리 전용 위젯
class BottomNavIcon extends StatelessWidget {
  final String assetPath;
  final bool selected;

  const BottomNavIcon({
    required this.assetPath,
    required this.selected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          assetPath,
          width: 24.w,
          color: selected ? AppColors.appGreenColor : Colors.white,
        ),
        SizedBox(height: 5.h),
      ],
    );
  }
}

// featureItems 그리드 아이템 별도 위젯 분리
class FeatureGridItem extends StatelessWidget {
  final FeatureItem item;
  final bool isVybe;
  final VoidCallback onTap;

  const FeatureGridItem({
    required this.item,
    this.isVybe = false,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isVybe ? _buildGradientBorderIcon() : _buildSimpleIcon(),
          SizedBox(height: 4.h),
          Text(
            item.label,
            style: TextStyle(
              color: Color(0xFFECECEC),
              fontSize: 12.sp,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.60,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBorderIcon() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFC1EF74),
            Color(0xFFF192DF),
            Color(0xFF7731FD),
            Color(0xFF7731FD),
            Color(0xFF7731FD),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: EdgeInsets.all(2), // 테두리 두께
        decoration: BoxDecoration(
          color: Color(0xFF2F2F33),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: SizedBox(
            width: 40.sp,
            height: 40.sp,
            child: SvgPicture.asset(item.iconPath),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleIcon() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        color: Color(0xFF2F2F33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: SizedBox(
          width: 40.sp,
          height: 40.sp,
          child: SvgPicture.asset(item.iconPath),
        ),
      ),
    );
  }
}

// 메인 UI 클래스
class Home05Main extends StatefulWidget {
  const Home05Main({super.key});

  @override
  State<Home05Main> createState() => _Home05Main();
}

class _Home05Main extends State<Home05Main> {
  @override
  void initState() {
    _fetchImages();
    super.initState();
  }

  Future<void> _fetchImages() async {
    final ref = FirebaseStorage.instance.ref('nearClub/test_1.png');
    final url = await ref.getDownloadURL();
    print(url);
  }

  final List<String> banners = [
    'assets/images/banner_1.png',
    'assets/images/banner_2.png',
    'assets/images/banner_3.png',
  ];

  final List<FeatureItem> featureItems = [
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_1.svg',
      label: 'VYBE 추천',
    ),
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_2.svg',
      label: '핫플레이스',
    ),
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_3.svg',
      label: '입장료 무료',
    ),
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_4.svg',
      label: '서비스 음료',
    ),
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_5.svg',
      label: '힙합',
    ),
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_6.svg',
      label: 'EDM',
    ),
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_7.svg',
      label: 'K-POP',
    ),
    FeatureItem(
      iconPath: 'assets/icons/mainpage/middle_button_8.svg',
      label: '라운지',
    ),
  ];

  int _selectedIndex = 0;

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return MainPage(banners: banners, featureItems: featureItems);
      case 1:
        return const LocationPage();
      case 2:
        return const PasswalletPage();
      case 3:
        return const SearchPage();
      case 4:
        return const MyinformationPage();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackgroundColor,
      appBar:
          _selectedIndex == 0
              ? AppBar(
                backgroundColor: AppColors.appBackgroundColor,
                elevation: 0,
                leadingWidth: 130.w,
                leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Image.asset(
                    'assets/images/main_logo.png',
                    fit: BoxFit.contain,
                    height: 44.h,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset('assets/icons/mainpage/search.svg'),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'assets/icons/mainpage/notifications_none.svg',
                    ),
                  ),
                  SizedBox(width: 24.w),
                ],
              )
              : null, // MainPage가 아니면 AppBar 없음
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          height: 95.h,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFF2F2F33), width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: AppColors.appBackgroundColor,
            selectedItemColor: AppColors.appGreenColor,
            unselectedItemColor: Colors.white,
            selectedLabelStyle: bottomNavSelectedLabelStyle,
            unselectedLabelStyle: bottomNavUnselectedLabelStyle,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: BottomNavIcon(
                  assetPath: 'assets/icons/bottom_navigator/home.svg',
                  selected: _selectedIndex == 0,
                ),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: BottomNavIcon(
                  assetPath: 'assets/icons/bottom_navigator/loaction.svg',
                  selected: _selectedIndex == 1,
                ),
                label: '주변',
              ),
              BottomNavigationBarItem(
                icon: BottomNavIcon(
                  assetPath: 'assets/icons/bottom_navigator/passwallet.svg',
                  selected: _selectedIndex == 2,
                ),
                label: '패스월렛',
              ),
              BottomNavigationBarItem(
                icon: BottomNavIcon(
                  assetPath: 'assets/icons/bottom_navigator/search.svg',
                  selected: _selectedIndex == 3,
                ),
                label: '검색',
              ),
              BottomNavigationBarItem(
                icon: BottomNavIcon(
                  assetPath: 'assets/icons/bottom_navigator/mypage.svg',
                  selected: _selectedIndex == 4,
                ),
                label: '내 정보',
              ),
            ],
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
      body: _buildBody(),
    );
  }
}

// MainPage 내부 Scaffold 제거 - 컨텐츠만 노출
class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
    required this.banners,
    required this.featureItems,
  });

  final List<String> banners;
  final List<FeatureItem> featureItems;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> nearClubImageUrls = []; // 주변 클럽 이미지 리스트
  bool isLoadingNearClub = true; // 로딩중 확인
  List<List<String>> nearClubName = [
    ['어썸레드', '홍대 · 클럽'],
    ['어썸', '홍대 · 클럽'],
    ['싱크홀', '홍대 · 클럽'],
    ['레이져', '홍대 · EDM'],
    ['버뮤다', '홍대 · EDM'],
    ['인클', '홍대 · 클럽'],
  ];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    // 이미지 추가 함수
    final urls = await FirebaseService.fetchNearClubImages();
    setState(() {
      nearClubImageUrls = urls;
      isLoadingNearClub = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(height: 13.h),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 18.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/mainpage/location_pin.svg'),
                  SizedBox(width: 4.w),
                  Text(
                    "내 주변 검색",
                    style: TextStyle(
                      color: const Color(0xFFECECEC),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.12,
                      letterSpacing: -0.80,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          CarouselSlider(
            options: CarouselOptions(
              height: 228.h,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
            ),
            items:
                widget.banners
                    .map(
                      (banner) => Image.asset(
                        banner,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                    .toList(),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 24.w,
                crossAxisSpacing: 24.w,
                childAspectRatio: 0.8,
              ),
              itemCount: widget.featureItems.length,
              itemBuilder: (context, index) {
                final item = widget.featureItems[index];
                return FeatureGridItem(
                  item: item,
                  isVybe: index == 0,
                  onTap: () => print('Clicked: ${item.label}'),
                );
              },
            ),
          ),
          SizedBox(height: 32.h),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 8.h,
            color: const Color(0xFF2F2F33),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Text(
                        "주변 클럽",
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
                    Row(
                      children: [
                        Text(
                          "전체보기",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFFCACACB),
                            fontSize: 12.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.17,
                            letterSpacing: -0.30,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          width: 4.sp,
                          'assets/icons/mainpage/showinfo_icon.svg',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     SizedBox(
                //       width: 112.w,
                //       child: Image.asset(
                //         'assets/images/near_club/test_1.png',
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //     SizedBox(height: 8.h),
                //     const Text(
                //       '홍대 클럽 레이저',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 14,
                //         fontFamily: 'Pretendard',
                //         fontWeight: FontWeight.w600,
                //         letterSpacing: -0.70,
                //       ),
                //     ),
                //     const Text(
                //       '홍대 · 클럽',
                //       style: TextStyle(
                //         color: Color(0xFF9F9FA1),
                //         fontSize: 12,
                //         fontFamily: 'Pretendard',
                //         fontWeight: FontWeight.w400,
                //         height: 1.17,
                //         letterSpacing: -0.30,
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(
                  height: 300,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount: nearClubImageUrls.length,
                    separatorBuilder: (_, __) => SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              nearClubImageUrls[index],
                              width: 112.w,
                              height: 112.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            nearClubName[index][0],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.70,
                            ),
                          ),
                          Text(
                            nearClubName[index][1],
                            style: TextStyle(
                              color: Color(0xFF9F9FA1),
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              height: 1.17,
                              letterSpacing: -0.30,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 기타 탭 화면들은 Scaffold 없이 간단히 콘텐츠만 노출
class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "주변 페이지",
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }
}

class PasswalletPage extends StatelessWidget {
  const PasswalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "패스월렛 페이지",
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "검색 페이지",
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }
}

class MyinformationPage extends StatelessWidget {
  const MyinformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "내 정보 페이지",
        style: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
    );
  }
}
