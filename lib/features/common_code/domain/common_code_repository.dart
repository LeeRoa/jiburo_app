import 'package:jiburo_app/core/constants/common_code_group.dart';
import 'package:jiburo_app/core/dto/common_code_response.dto.dart';

abstract class CommonCodeRepository {
  Future<Map<String, List<CommonCodeResponse>>> getAllCodes();
  Future<List<CommonCodeResponse>> getByGroup(CommonCodeGroup group);
}
