import 'package:jiburo_app/core/dto/common_code_response.dto.dart';

abstract class CommonCodeRepository {
  Future<Map<String, List<CommonCodeResponse>>> getAllCodes();
}
