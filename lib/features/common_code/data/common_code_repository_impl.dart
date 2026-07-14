import 'package:dio/dio.dart';
import 'package:jiburo_app/core/constants/common_code_group.dart';
import 'package:jiburo_app/core/dto/common_code_response.dto.dart';
import 'package:jiburo_app/core/network/api_endpoints.dart';
import 'package:jiburo_app/features/common_code/domain/common_code_repository.dart';

class CommonCodeRepositoryImpl implements CommonCodeRepository {
  final Dio dio;

  CommonCodeRepositoryImpl(this.dio);

  @override
  Future<Map<String, List<CommonCodeResponse>>> getAllCodes() async {
    final response = await dio.get(ApiEndpoints.commonCodes);

    final Map<String, dynamic> rawData = response.data['data'];

    return rawData.map(
      (key, value) => MapEntry(
        key,
        (value as List)
            .map((e) => CommonCodeResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
  }

  @override
  Future<List<CommonCodeResponse>> getByGroup(CommonCodeGroup group) async {
    final response = await dio.get(ApiEndpoints.commonCodesByGroup(group));
    final data = response.data['data'] as List;

    return data.map((e) => CommonCodeResponse.fromJson(e)).toList();
  }
}
