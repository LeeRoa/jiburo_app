import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/provider/locale_provider.dart';
import 'package:jiburo_app/core/utils/i18n_manager.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/routes/app_router.dart';

void main() async {
  // main에서 비동기 함수 사용할 때 필수
  WidgetsFlutterBinding.ensureInitialized();

  String deviceLanguage = PlatformDispatcher.instance.locale.languageCode;

  const supportedLanguages = ['ko', 'en'];

  // 지원하지 않는 언어의 경우 기본값 en
  String finalLanguage = supportedLanguages.contains(deviceLanguage)
      ? deviceLanguage
      : 'en';

  print('기기 접속언어: $finalLanguage');

  // 번역파일 로드
  await I18nManager.loadJson(finalLanguage);
  await initializeDateFormatting(finalLanguage);

  runApp(
    ProviderScope(
      overrides: [localeProvider.overrideWithValue(finalLanguage)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final language = ref.watch(localeProvider);

        return MaterialApp.router(
          theme: ThemeData(fontFamily: "Pretendard"),
          routerConfig: appRouter,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('ko', 'KR'), Locale('en', 'US')],
          locale: Locale(language),
        );
      },
    );
  }
}
