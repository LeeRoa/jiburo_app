import 'dart:convert';

import 'package:flutter/services.dart';

class I18nManager {
  static Map<String, String> _localizedStrings = {};

  static Future<void> loadJson(String languageCode) async {
    try {
      String jsonString = await rootBundle.loadString(
        'assets/i18n/$languageCode.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      _localizedStrings = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    } catch (e) {
      print("다국어 파일 로드 실패: $e");
    }
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
