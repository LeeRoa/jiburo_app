import 'package:jiburo_app/features/lost_post/dto/lost_post_create_request.dto.dart';

abstract class LostPostRepository {
  Future<void> createPost(LostPostCreateRequest request);
}
