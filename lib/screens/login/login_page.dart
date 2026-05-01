import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/screens/login/widget/login_section.dart';
import 'package:jiburo_app/widgets/plain_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
