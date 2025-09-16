// TODO: 바텀 네비게이터

class MainTabMeta {
  final String label;
  final String iconAsset;
  const MainTabMeta({required this.label, required this.iconAsset});
}

const List<MainTabMeta> mainTabs = [
  MainTabMeta(label: '홈', iconAsset: 'assets/icons/bottom_nav/home.svg'),
  MainTabMeta(label: '주변', iconAsset: 'assets/icons/bottom_nav/loaction.svg'),
  MainTabMeta(
    label: '패스월렛',
    iconAsset: 'assets/icons/bottom_nav/passwallet.svg',
  ),
  MainTabMeta(label: '검색', iconAsset: 'assets/icons/bottom_nav/search.svg'),
  MainTabMeta(label: '내 정보', iconAsset: 'assets/icons/bottom_nav/mypage.svg'),
];
