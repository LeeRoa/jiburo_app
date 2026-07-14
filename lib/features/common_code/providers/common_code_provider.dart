import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiburo_app/core/constants/common_code_group.dart';
import 'package:jiburo_app/core/dto/common_code_response.dto.dart';
import 'package:jiburo_app/core/network/dio_client.dart';
import 'package:jiburo_app/features/common_code/data/common_code_repository_impl.dart';
import 'package:jiburo_app/features/common_code/domain/common_code_repository.dart';

final commonCodeRepositoryProvider = Provider<CommonCodeRepository>((ref) {
  return CommonCodeRepositoryImpl(ref.read(dioProvider));
});

final commonCodeProvider =
    FutureProvider<Map<String, List<CommonCodeResponse>>>((ref) async {
      final repository = ref.read(commonCodeRepositoryProvider);
      return repository.getAllCodes();
    });

final commonCodeByGroupProvider =
    FutureProvider.family<List<CommonCodeResponse>, CommonCodeGroup>((
      ref,
      group,
    ) async {
      final repository = ref.read(commonCodeRepositoryProvider);
      return repository.getByGroup(group);
    });

extension CommonCodeX on Map<String, List<CommonCodeResponse>> {
  List<CommonCodeResponse> byGroup(CommonCodeGroup group) =>
      this[group.value] ?? [];
}
