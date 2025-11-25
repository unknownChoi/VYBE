import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  // 유저 DB에 존재하는지 확인 함수 (매개변수: 전화번호)
  static Future<bool> isUserExists(String phoneNumber) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(phoneNumber)
        .get();

    return doc.exists;
  }

  static Future<List<String>> fetchNearClubImages() async {
    final ListResult result = await FirebaseStorage.instance
        .ref('nearClub')
        .listAll();
    List<String> urls = [];
    for (final ref in result.items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }

  /// 홈 배너 이미지를 Storage에서 내려받아 URL 리스트로 반환한다.
  /// 기본 경로는 'homeBanners' 이며, 필요시 [path]로 오버라이드한다.
  static Future<List<String>> fetchHomeBannerImages({
    String path = 'bannerAd',
  }) async {
    final ListResult result = await FirebaseStorage.instance
        .ref(path)
        .listAll();
    final items = result.items.toList()
      ..sort((a, b) => a.name.compareTo(b.name)); // 파일명 기준 정렬

    final List<String> urls = [];
    for (final ref in items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}
