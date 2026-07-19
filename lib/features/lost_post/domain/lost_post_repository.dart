import 'dart:io';

import 'package:jiburo_app/features/lost_post/dto/lost_post_create_request.dto.dart';
import 'package:jiburo_app/features/lost_post/dto/presigned_url_request.dto.dart';

abstract class LostPostRepository {
  Future<void> createPost(LostPostCreateRequest request);
  Future<String> uploadImage(File file, {FileCode fileCode = FileCode.post});
}
