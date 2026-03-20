import 'package:flutter/material.dart';
import 'package:jiburo_app/routes/app_router.dart';
import 'package:jiburo_app/screens/not_found_page.dart';
import 'package:jiburo_app/screens/splash_loading_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(fontFamily: "Pretendard"),
      routerConfig: appRouter,
    );
    // return MaterialApp(
    //   theme: ThemeData(fontFamily: "Pretendard"),
    //
    //   home: NotFoundPage(),
    // );
  }
}
