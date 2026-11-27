import 'package:dio/dio.dart';
import 'package:jiburo_app/core/dto/api_response.dto.dart';

/// ApiResponse 래퍼에서 data를 꺼냄. success가 false이면 예외
dynamic unwrapApi(dynamic body) {
  final api = ApiResponseDto<Object?>.fromJson(
    body as Map<String, dynamic>,
    (j) => j,
  );
  if (!api.success) {
    throw Exception(api.message ?? '요청에 실패했어요');
  }
  return api.data;
}

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
