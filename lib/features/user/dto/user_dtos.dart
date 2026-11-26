import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';

/// 내 프로필 (GET /users/me)
class UserProfile {
  final String nickname;
  final String email;
  final String? profileImageUrl;
  final String provider; // kakao, google, naver, dev
  final String badgeCode;
  final int activityScore;
  final bool notificationEnabled;
  final bool locationEnabled;

  const UserProfile({
    required this.nickname,
    required this.email,
    required this.profileImageUrl,
    required this.provider,
    required this.badgeCode,
    required this.activityScore,
    required this.notificationEnabled,
    required this.locationEnabled,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    nickname: json['nickname'] as String? ?? '',
    email: json['email'] as String? ?? '',
    profileImageUrl: json['profileImageUrl'] as String?,
    provider: json['provider'] as String? ?? '',
    badgeCode: json['badgeCode'] as String? ?? '',
    activityScore: (json['activityScore'] as num?)?.toInt() ?? 0,
    notificationEnabled: json['notificationEnabled'] as bool? ?? false,
    locationEnabled: json['locationEnabled'] as bool? ?? false,
  );

  String get providerLabel => switch (provider) {
    'kakao' => '카카오 로그인',
    'google' => '구글 로그인',
    'naver' => '네이버 로그인',
    'dev' => '개발용 로그인',
    _ => '소셜 로그인',
  };

  // 활동 점수 → 레벨/경험치 환산: 100점마다 1레벨 (기획 확정 전 임시 기준)
  static const xpPerLevel = 100;
  int get level => activityScore ~/ xpPerLevel + 1;
  int get xp => activityScore % xpPerLevel;
}

/// 내 게시물 한 페이지 (GET /users/me/posts)
class MyPostsPage {
  final List<PostSummary> items;
  final int total;
  const MyPostsPage({required this.items, required this.total});

  factory MyPostsPage.fromJson(Map<String, dynamic> json) {
    final items = (json['content'] as List<dynamic>? ?? [])
        .map((e) => PostSummary.fromJson(e as Map<String, dynamic>))
        .toList();
    // 스프링 PagedModel(page.totalElements) 또는 기존 Page(totalElements) 모두 허용
    final page = json['page'];
    final total =
        (page is Map ? page['totalElements'] : json['totalElements']) as num?;
    return MyPostsPage(items: items, total: total?.toInt() ?? items.length);
  }
}

/// 내 활동(주변 탐색 세션) 한 건 (GET /users/me/activities)
class MyActivity {
  final String id;
  final String postId;
  final String postTitle;
  final String? postImageUrl;
  final String statusCode; // ACTIVE, SUBMITTED, CANCELLED
  final DateTime? createdAt;

  const MyActivity({
    required this.id,
    required this.postId,
    required this.postTitle,
    required this.postImageUrl,
    required this.statusCode,
    required this.createdAt,
  });

  factory MyActivity.fromJson(Map<String, dynamic> json) => MyActivity(
    id: json['id'] as String,
    postId: json['postId'] as String? ?? '',
    postTitle: json['postTitle'] as String? ?? '',
    postImageUrl: json['postImageUrl'] as String?,
    statusCode: json['statusCode'] as String? ?? '',
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.tryParse(json['createdAt'] as String),
  );
}
