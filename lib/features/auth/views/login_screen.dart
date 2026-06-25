import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/views/widgets/plain_layout.dart';

import 'widget/login_section.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/images/logos/homeLogo.svg",
                  width: 120,
                ),
              ),
            ),
            LoginSection(),
          ],
        ),
      ),
    );
  }
}
