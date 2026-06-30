import 'package:dio/dio.dart';
import 'package:jiburo_app/core/network/token_holder.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final isAuthEndpoint =
        options.path.contains('/auth/sign-in') ||
        options.path.contains('/auth/reissue');

    if (TokenHolder.accessToken != null && !isAuthEndpoint) {
      options.headers['Authorization'] = 'Bearer ${TokenHolder.accessToken}';
    }

    handler.next(options);
  }
}
