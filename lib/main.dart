import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helloflutter/states/authen.dart';
import 'package:helloflutter/states/main_home.dart';

var getPage = <GetPage<dynamic>>[
  GetPage(
    name: '/authen',
    page: () => const Authen(),
  ),
  GetPage(
    name: '/mainHome',
    page: () => const MainHome(),
  ),
];
String firstState = '/authen';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverride();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().then((value) {
    //มีการ login อยู่หรือไม่ จะส่งมาที่ event
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        firstState = '/mainHome';
      }
    });

    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //  home: Authen(),
      getPages: getPage,
      initialRoute: firstState,
    );
  }
}

class MyHttpOverride extends HttpOverrides {
  //สร้าง cer
  @override
  HttpClient createHttpClient(SecurityContext? context) {

    //.. 2 จุดต้องการ
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
