import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:vybe/features/club_detail_page/screens/club_detail_main.dart';

import 'package:vybe/firebase_options.dart';

void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  final List<ConnectivityResult> connectivityResults =
      await Connectivity().checkConnectivity();
  final bool isNetworkAvailable = connectivityResults.any(
    (result) => result != ConnectivityResult.none,
  );

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FlutterNaverMap().init(
    clientId: '6jetyz32jo',
    onAuthFailed:
        (ex) => switch (ex) {
          NQuotaExceededException(:final message) => print(
            "사용량 초과 (message: $message)",
          ),
          NUnauthorizedClientException() ||
          NClientUnspecifiedException() ||
          NAnotherAuthFailedException() => print("인증 실패: $ex"),
        },
  );
  runApp(MyApp(isNetworkAvailable: isNetworkAvailable));
}

class MyApp extends StatelessWidget {
  final bool isNetworkAvailable;
  const MyApp({required this.isNetworkAvailable, super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // 디자인 시안 해상도 (가로x세로)
      minTextAdapt: true, // 텍스트 크기 자동 조정 활성화
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false, // 디버그 배너 숨김
          home:
              isNetworkAvailable
                  ? ClubDetailMain()
                  : Scaffold(
                    body: Center(
                      child: Text(
                        '네트워크에 연결되어 있지 않습니다.',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
