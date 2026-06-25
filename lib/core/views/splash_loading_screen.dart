import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:jiburo_app/core/routes/app_paths.dart';
import 'package:jiburo_app/state/location_state.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:kakao_map_sdk/kakao_map_sdk.dart';

class SplashLoadingScreen extends StatefulWidget {
  const SplashLoadingScreen({super.key});

  @override
  State<SplashLoadingScreen> createState() => _SplashLoadingScreenState();
}

class _SplashLoadingScreenState extends State<SplashLoadingScreen> {
  bool isLogin = true;

  Future<void> _initNavigate() async {
    await Future.wait([
      _initKakaoMap(),
      _getCurrentLocation(),
      Future.delayed(Duration(seconds: 3)),
    ]);

    if (!mounted) return;

    if (isLogin) {
      context.go(AppPaths.home);
    } else {
      context.go(AppPaths.login);
    }

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => Navigators()),
    // );
  }

  Future<void> _initKakaoMap() async {
    await KakaoMapSdk.instance.initialize('54b8d7c26f777cbf09b20c3760b731d5');
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    // 권한 확인 후 위치 요청
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.medium),
    );

    LocationState.lat = position.latitude;
    LocationState.lng = position.longitude;
  }

  @override
  void initState() {
    super.initState();
    _initNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.point50,
      body: Padding(
        padding: const EdgeInsets.only(top: 150, bottom: 45),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/pet-img.png'),
                      SvgPicture.asset('assets/images/pet-icons.svg'),
                    ],
                  ),
                  SizedBox(height: 27),
                  SvgPicture.asset('assets/images/text.svg'),
                ],
              ),
              SizedBox(height: 181),
              SvgPicture.asset(
                'assets/images/logos/Jiburo-text-logo-white.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
