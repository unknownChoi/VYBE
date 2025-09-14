import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  // 유저 DB에 존재하는지 확인 함수 (매개변수: 전화번호)
  static Future<bool> isUserExists(String phoneNumber) async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(phoneNumber)
            .get();

    return doc.exists;
  }

  static Future<List<String>> fetchNearClubImages() async {
    final ListResult result =
        await FirebaseStorage.instance.ref('nearClub').listAll();
    List<String> urls = [];
    for (final ref in result.items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}
