import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/routes/app_paths.dart';
import 'package:jiburo_app/styles/colors.dart';
import 'package:jiburo_app/styles/fonts.dart';
import 'package:jiburo_app/widgets/buttons/main_btn.dart';
import 'package:jiburo_app/widgets/plain_layout.dart';
import 'package:lottie/lottie.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlainLayout(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset('assets/images/404.svg'),
                LottieBuilder.asset(
                  'assets/lottie/Loader cat.json',
                  frameRate: FrameRate.composition,
                  width: 250,
                  height: 250,
                ),
                Positioned(
                  top: 190,
                  child: Text(
                    '앗! 잘해보려 했는데\n뭔가 문제가 생겼네요',
                    style: AppFonts.t2B.copyWith(color: AppColors.neutral30),
                  ),
                ),
              ],
            ),
            SizedBox(height: 62),
            MainBtn(
              size: Size.medium,
              btnName: '이전으로 돌아가기',
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppPaths.home);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
