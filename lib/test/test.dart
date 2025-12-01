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

/// ----------------------
///  Firestore 업로드 함수
/// ----------------------

Future<void> uploadMenusForClub(String clubId) async {
  final menusRef = FirebaseFirestore.instance
      .collection('clubs')
      .doc(clubId)
      .collection('menus');

  menuItemsData.forEach((category, items) async {
    for (final item in items) {
      final map = Map<String, dynamic>.from(item as Map);

      // 카테고리 추가
      map['category'] = category;

      // Firestore에 문서 추가
      await menusRef.add(map);
    }
  });
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
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('THIS IS TEST PAGE FOR BACKEND WORK')),
    );
  }
}
