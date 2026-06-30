import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/features/auth/data/auth_repository_impl.dart';
import 'package:jiburo_app/features/auth/providers/auth_provider.dart';

class ReissueInterceptor extends Interceptor {
  final Dio dio;
  final Ref ref; // 순환 참조 방지

  ReissueInterceptor({required this.dio, required this.ref});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        // 이 시점에서 무한루프가 발생 하지 않음
        final newAccessToken = await ref.read(authRepositoryProvider).reissue();

        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e) {
        ref.read(authProvider.notifier).logout();
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}
