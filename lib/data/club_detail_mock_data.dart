import 'package:flutter/material.dart';

class Review {
  final String author;
  final double rating;
  final String date;
  final String content;
  final List<String>? imageUrls;
  const Review({
    required this.author,
    required this.rating,
    required this.date,
    required this.content,
    this.imageUrls,
  });
}

final clubData = {
  'name': '어썸레드',
  'category': '홍대 | 힙합클럽',
  'tags': ["#힙합", "#대중적", "#무료입장", "#EDM"],
  'rating': "4.76",
  'reviews': "13",
  'description': "홍대역 인근 입문자에 좋은 힙합 클럽",
  'address': "서울 마포구 잔다리로 12 지하 1층",
  'subwayInfo': {
    'line': '5',
    'exitNum': '2',
    'station': '상수역',
    'distance': '422m',
  },
  'addressCoords': {'x': 37.550947012, 'y': 126.921849684},
  'instagramUrl': "https://www.instagram.com/awesomered_omg",
  'entryFee': "입장료 0 ~ 10,000원",
  'phoneNumber': "02-1234-1234",
  'guidelines':
      "* 성인만 입장 가능합니다.\n* 프로모션 기간에는 운영 시간과 가격이 변동될 수 있습니다.\n* 예약 변경 및 취소는 방문일 전 3일 까지 앱을 통해 가능하며, 2일 ~ 하루 전 취소 시 50% 환불, 당일 취소 및 노쇼 환불 불가",
  'businessHoursSummary': "매일 11:00 ~ 02:00 (일요일 정기 휴무)",
  'openChatLink': "open.kakao.com/o/gYnkW0yf",
  'coverImage': [
    'assets/images/test_image/test_image.png',
    'assets/images/test_image/backgroundImage.png',
  ],
  'images': [
    'assets/images/test_image/test_image_3.png',
    'assets/images/test_image/test_image_4.png',
    'assets/images/test_image/test_image_5.png',
  ],
  'menuImages': [
    'assets/images/test_image/menu_image_1.png',
    'assets/images/test_image/menu_image_2.png',
    'assets/images/test_image/menu_image_3.png',
  ],
};
final businessHours = const [
  {'day': '월', 'hours': '11:00 - 02:00'},
  {'day': '화', 'hours': '11:00 - 02:00'},
  {'day': '수', 'hours': '11:00 - 02:00'},
  {'day': '목', 'hours': '11:00 - 02:00'},
  {'day': '금', 'hours': '11:00 - 02:00'},
  {'day': '토', 'hours': '11:00 - 02:00'},
  {'day': '일', 'hours': '정기휴무 (매주 일요일)'},
];
final menuItemsData = const {
  "대표메뉴": [
    {
      "name": "LEMON DROP",
      "price": 100000,
      "image": "assets/images/test_image/test_image_2.png",
      "isMain": true,
    },
    {
      "name": "ORORA SET",
      "price": 249000,
      "image": "assets/images/test_image/test_image_2.png",
      "isMain": true,
    },
  ],
  "SET": [
    {
      "name": "VODKA SET",
      "price": 180000,
      "image": "assets/images/test_image/test_image_2.png",
      "isMain": false,
    },
    {"name": "NO IMAGE SET", "price": 150000, "image": "", "isMain": false},
  ],
  "HARD": [
    {
      "name": "VODKA SET",
      "price": 180000,
      "image": "assets/images/test_image/test_image_2.png",
      "isMain": false,
    },
  ],
  "BEER": [
    {"name": "LAGER LIGHT", "price": 8000, "image": "", "isMain": true},
  ],
  "DRINK": [
    {"name": "COLA CLASSIC", "price": 4000, "image": "", "isMain": false},
  ],
};
const menuCategories = ["대표메뉴", "SET", "HARD", "BEER", "DRINK"];
const photoTabImageList = [
  "assets/images/test_image/club_image_1.png",
  "assets/images/test_image/club_image_2.png",
  "assets/images/test_image/club_image_3.png",
  "assets/images/test_image/club_image_4.png",
  "assets/images/test_image/club_image_5.png",
  "assets/images/test_image/club_image_6.png",
  "assets/images/test_image/club_image_7.png",
  "assets/images/test_image/club_image_8.png",
];

final List<Map<String, dynamic>> reviewsData = const [
  {
    'author': '음악 애호가',
    'rating': "4.5",
    'date': '2025.08.22',
    'content':
        '분위기최고!음악도너무좋고,사람들도다들친절해서좋았어요.다음에또올게요!분위기최고!음악도너무좋고,사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들사람들ㅍ',
    'imageUrls': ['assets/images/test_image/review_test_image.png'],
  },
  {
    'author': '파티 피플',
    'rating': "5.0",
    'date': '2025.08.21',
    'content': '주말에 친구들이랑 방문했는데 정말 재밌게 놀다 갑니다. 특히 디제잉이 인상 깊었어요.',
    'imageUrls': [
      'assets/images/test_image/test_image_2.png',
      'assets/images/test_image_3.png',
    ],
  },
  {
    'author': '힙합 리스너',
    'rating': "4.0",
    'date': '2025.08.20',
    'content': '칵테일 종류가 다양해서 좋았어요. 맛도 훌륭했고요. 추천합니다!',
    'imageUrls': null,
  },
  {
    'author': '단골 손님',
    'rating': "4.8",
    'date': '2025.08.19',
    'content': '입장료가 없어서 부담 없이 즐길 수 있었어요. 가성비 최고 클럽!',
    'imageUrls': [
      'assets/images/test_image/test_image_4.png',
      'assets/images/test_image_5.png',
      'assets/images/test_image/club_image_1.png',
    ],
  },
  {
    'author': '익명의 사자',
    'rating': "3.5",
    'date': '2025.08.18',
    'content': '음악 소리가 조금 크긴 했지만, 스트레스 풀기에는 딱 좋았습니다.',
    'imageUrls': null,
  },
  {
    'author': '새로운 방문자',
    'rating': "4.2",
    'date': '2025.08.15',
    'content': '직원분들이 정말 친절하세요. 덕분에 편안하게 즐길 수 있었습니다.',
    'imageUrls': ['assets/images/test_image/test_image_4.png'],
  },
  {
    'author': '홍대 지킴이',
    'rating': "5.0",
    'date': '2025.08.12',
    'content': '새벽까지 시간 가는 줄 모르고 놀았네요. 홍대 최고의 클럽입니다!',
    'imageUrls': null,
  },
  {
    'author': '음악 찾아 삼만리',
    'rating': "4.6",
    'date': '2025.08.10',
    'content': '외관이 깔끔해서 들어가보니 내부도 너무 깨끗하고 음악도 너무 좋네요. 술 종류도 다양해서 잘 놀다왔어요.',
    'imageUrls': [
      'assets/images/test_image/test_image_5.png',
      'assets/images/test_image/club_image_1.png',
    ],
  },
  {
    'author': '파티 투나잇',
    'rating': "3.9",
    'date': '2025.08.05',
    'content': '친구가 추천해서 와봤는데, 기대 이상이었어요! 다음에 또 오고 싶네요.',
    'imageUrls': null,
  },
  {
    'author': '리듬 타는 어피치',
    'rating': "4.3",
    'date': '2025.08.01',
    'content': '다양한 음악을 즐길 수 있어서 좋았습니다. 춤추기 좋은 곳이에요.',
    'imageUrls': ['assets/images/test_image/review_test_image.png'],
  },
];
