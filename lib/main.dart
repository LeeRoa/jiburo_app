import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/home/home_page.dart';
import 'package:jiburo_app/screens/loading_page.dart';
import 'package:jiburo_app/screens/login/login_page.dart';
import 'package:jiburo_app/widgets/main_layout.dart';

void main() {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "Pretendard"),
      // home: LoadingPage(),
      home: isLogin ? MainLayout(child: HomePage()) : LoginPage(),
    );
  }
}
