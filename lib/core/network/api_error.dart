import 'package:dio/dio.dart';

/// 서버 오류 응답(ApiResponse 실패)의 안내 문구. 없으면 [fallback]
String apiErrorMessage(Object e, {String fallback = '요청에 실패했어요'}) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      final message = data['message'] as String;
      if (message.isNotEmpty) return message;
    }
  }
  return fallback;
}

/// 서버 오류 응답의 errorCode (예: DUPLICATE_NICKNAME)
String? apiErrorCode(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map && data['errorCode'] is String) {
      return data['errorCode'] as String;
    }
  }
  return null;
}
