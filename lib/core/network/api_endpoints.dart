import 'package:jiburo_app/core/constants/common_code_group.dart';

class ApiEndpoints {
  static const String _apiPrefix = '/api/v1';

  //common
  static final commonCodes = '$_apiPrefix/common-codes';
  static String commonCodesByGroup(CommonCodeGroup group) =>
      '$_apiPrefix/common-codes/$group';

  // lostPosts
  static final posts = '$_apiPrefix/posts';
  static String postById(String id) => '$_apiPrefix/posts/$id';
  static String postsByIdPatch(String id) => '$_apiPrefix/posts/$id/status';
  static final postSearch = '$_apiPrefix/posts/search';
  static final postNearBy = '$_apiPrefix/posts/nearby';
  static final postMap = '$_apiPrefix/posts/map';

  // auth
  static final authReissue = '$_apiPrefix/auth/reissue';

  //image
  static final presignedUrl = '$_apiPrefix/images/presigned-url';
  static final imageComplete = '$_apiPrefix/images/complete';

  //notification
  static final notification = '$_apiPrefix/notifications';
  static final notifyUnreadCnt = '$_apiPrefix/notifications/unread-count';

  // chat
  static final rooms = '$_apiPrefix/chat/rooms';
  static String roomsMessage(String roomId) =>
      '$_apiPrefix/chat/rooms/$roomId/message';
  static String roomsSearch(String roomId) =>
      '$_apiPrefix/chat/rooms/$roomId/message/search';
}
