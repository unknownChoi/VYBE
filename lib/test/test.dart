import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// ----------------------
///  너가 가진 테스트 데이터
/// ----------------------

final menuItemsData = const {
  "대표메뉴": [
    {
      "name": "LEMON DROP",
      "price": 100000,
      "image": "assets/images/test_image/test_image_2.png",
      "description": "CHOICE A OPERA BRUIT",
      "isMain": true,
      "options": [
        {"name": "얼음 추가", "price": 0},
        {"name": "라임 웨지", "price": 1000},
        {"name": "샷 추가", "price": 5000},
      ],
    },
    {
      "name": "ORORA SET",
      "price": 249000,
      "image": "assets/images/test_image/test_image_2.png",
      "description": "CHOICE A OPERA BRUITCHOICE A",
      "isMain": true,
    },
    {
      "name": "BLUE LAGOON",
      "price": 129000,
      "image": "",
      "description": "SIGNATURE CITRUS & VODKA",
      "isMain": true,
    },
    {
      "name": "MIDNIGHT SANGRIA",
      "price": 139000,
      "image": "",
      "description": "RED WINE FRUIT BLEND",
      "isMain": true,
    },
  ],
  "SET": [
    {
      "name": "VODKA SET",
      "price": 180000,
      "image": "assets/images/test_image/test_image_2.png",
      "description": "",
      "isMain": false,
    },
    {
      "name": "NO IMAGE SET",
      "price": 150000,
      "image": "",
      "description": "",
      "isMain": false,
    },
    {
      "name": "GIN & TONIC SET",
      "price": 165000,
      "image": "assets/images/test_image/test_image_5.png",
      "description": "GIN + TONIC + LIME",
      "isMain": false,
      "options": [
        {"name": "토닉 추가(1캔)", "price": 2000},
        {"name": "라임 추가", "price": 1000},
      ],
    },
  ],
  "HARD": [
    {
      "name": "VODKA SET",
      "price": 180000,
      "image": "assets/images/test_image/test_image_2.png",
      "description": "",
      "isMain": false,
    },
    {
      "name": "RUM SET",
      "price": 170000,
      "image": "",
      "description": "DARK RUM + COLA",
      "isMain": false,
      "options": [
        {"name": "콜라 추가(1캔)", "price": 1500},
        {"name": "라임 웨지", "price": 1000},
      ],
    },
  ],
  "BEER": [
    {
      "name": "LAGER LIGHT",
      "price": 8000,
      "image": "",
      "description": "",
      "isMain": true,
    },
    {
      "name": "IPA HOPPY",
      "price": 9000,
      "image": "",
      "description": "",
      "isMain": false,
      "options": [
        {"name": "잔 추가", "price": 0},
        {"name": "코스터(기념)", "price": 1000},
      ],
    },
  ],
  "DRINK": [
    {
      "name": "COLA CLASSIC",
      "price": 4000,
      "image": "",
      "description": "",
      "isMain": false,
    },
    {
      "name": "GINGER ALE",
      "price": 4000,
      "image": "",
      "description": "",
      "isMain": false,
    },
  ],
};

const menuCategories = ["대표메뉴", "SET", "HARD", "BEER", "DRINK"];

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

/// ----------------------
///  Firestore 업로드 함수
/// ----------------------

// Future<void> uploadMenusForClub(String clubId) async {
//   final menusRef = FirebaseFirestore.instance
//       .collection('clubs')
//       .doc(clubId)
//       .collection('menus');

//   menuItemsData.forEach((category, items) async {
//     for (final item in items) {
//       final map = Map<String, dynamic>.from(item as Map);

//       // 카테고리 추가
//       map['category'] = category;

//       // Firestore에 문서 추가
//       await menusRef.add(map);
//     }
//   });
// }

Future<void> uploadReviews() async {
  final firestore = FirebaseFirestore.instance;

  for (final item in reviewsData) {
    final map = Map<String, dynamic>.from(item as Map);
    print(map);

    await firestore
        .collection('clubs')
        .doc('test_awsomered_h_1')
        .collection('reviews')
        .add(map);
  }
}

/// ----------------------
///  테스트 페이지 (init에서 한번 실행)
/// ----------------------

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    uploadReviews();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('THIS IS TEST PAGE FOR BACKEND WORK')),
    );
  }
}
