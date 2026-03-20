import 'package:flutter/material.dart';
import 'package:jiburo_app/screens/home/home_page.dart';
import 'package:jiburo_app/screens/home/notification_page.dart';

class HomeTabWidget extends StatelessWidget {
  const HomeTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/notification') {
          return MaterialPageRoute(builder: (_) => NotificationPage());
        }
        return MaterialPageRoute(builder: (_) => HomePage());
      },
    );
  }
}
