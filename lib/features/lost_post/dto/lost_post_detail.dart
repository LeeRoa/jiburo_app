import 'package:jiburo_app/features/lost_post/dto/post_summary.dart';

/// 게시글 상세 (GET /posts/{id})
class LostPostDetail {
  final String id;
  final String authorId;
  final String authorNickname;
  final String title;
  final String content;
  final String statusCode; // LOST, PROTECTING, COMPLETE
  final String categoryCode;
  final AnimalDetail? animal;
  final List<String> imageUrls;
  final double? latitude;
  final double? longitude;
  final String foundLocation;
  final DateTime? lostDate;
  final int reward; // 원 단위
  final DateTime? createdAt;
  final bool isLiked;
  final int likeCount;

  const LostPostDetail({
    required this.id,
    required this.authorId,
    required this.authorNickname,
    required this.title,
    required this.content,
    required this.statusCode,
    required this.categoryCode,
    required this.animal,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
    required this.foundLocation,
    required this.lostDate,
    required this.reward,
    required this.createdAt,
    required this.isLiked,
    required this.likeCount,
  });

  factory LostPostDetail.fromJson(Map<String, dynamic> json) {
    final detail = json['detail'];
    return LostPostDetail(
      id: json['id'] as String,
      authorId: json['authorId'] as String? ?? '',
      authorNickname: json['authorNickname'] as String? ?? '',
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      statusCode: json['statusCode'] as String? ?? '',
      categoryCode: json['categoryCode'] as String? ?? '',
      animal: detail is Map<String, dynamic> && detail['type'] == 'ANIMAL'
          ? AnimalDetail.fromJson(detail)
          : null,
      imageUrls: (json['imageUrls'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      foundLocation: json['foundLocation'] as String? ?? '',
      lostDate: json['lostDate'] == null
          ? null
          : DateTime.tryParse(json['lostDate'] as String),
      reward: (json['reward'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.tryParse(json['createdAt'] as String),
      isLiked: json['isLiked'] as bool? ?? false,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
    );
  }

  bool get isComplete => statusCode == 'COMPLETE';

  /// 목록·카드에서 쓰는 요약으로 변환
  PostSummary toSummary() => PostSummary(
    id: id,
    title: title,
    foundLocation: foundLocation,
    latitude: latitude,
    longitude: longitude,
    reward: reward,
    createdAt: createdAt,
    imageUrl: imageUrls.isEmpty ? null : imageUrls.first,
    statusCode: statusCode,
  );
}

/// 동물 상세 (detail.type == ANIMAL)
class AnimalDetail {
  final String name;
  final String animalTypeCode; // DOG, CAT, ETC
  final String? animalTypeCustom;
  final String? breed;
  final String? genderCode; // MALE, FEMALE, UNKNOWN
  final String? color;
  final int? age;
  final double? weight;
  final bool? isBiting;

  const AnimalDetail({
    required this.name,
    required this.animalTypeCode,
    this.animalTypeCustom,
    this.breed,
    this.genderCode,
    this.color,
    this.age,
    this.weight,
    this.isBiting,
  });

  factory AnimalDetail.fromJson(Map<String, dynamic> json) => AnimalDetail(
    name: json['name'] as String? ?? '',
    animalTypeCode: json['animalTypeCode'] as String? ?? '',
    animalTypeCustom: json['animalTypeCustom'] as String?,
    breed: json['breed'] as String?,
    genderCode: json['genderCode'] as String?,
    color: json['color'] as String?,
    age: (json['age'] as num?)?.toInt(),
    weight: (json['weight'] as num?)?.toDouble(),
    isBiting: json['isBiting'] as bool?,
  );

  /// 동물 종류 표기: 고양이 / 코리안 숏헤어
  String get typeLabel {
    final type = switch (animalTypeCode) {
      'DOG' => '강아지',
      'CAT' => '고양이',
      _ => (animalTypeCustom?.isNotEmpty ?? false) ? animalTypeCustom! : '기타',
    };
    final b = breed;
    return (b == null || b.isEmpty) ? type : '$type / $b';
  }

  /// 특징 표기: 5살 / 13kg / 물지 않아요 (값이 있는 것만)
  String get featureLabel {
    final parts = <String>[
      if (age != null) '$age살',
      if (weight != null) '${_trim(weight!)}kg',
      if (isBiting != null) isBiting! ? '물 수 있어요' : '물지 않아요',
    ];
    return parts.join(' / ');
  }

  static String _trim(double v) =>
      v == v.roundToDouble() ? '${v.toInt()}' : '$v';
}

/// 게시글에 달린 탐색 기록 한 건 (GET /posts/{id}/finder-sessions, 작성자 전용)
class FinderNote {
  final String id;
  final String statusCode; // ACTIVE, SUBMITTED, CANCELLED
  final String? resultCode; // FOUND, NOT_FOUND
  final String? note;
  final double startLatitude;
  final double startLongitude;
  final DateTime? createdAt;

  const FinderNote({
    required this.id,
    required this.statusCode,
    required this.resultCode,
    required this.note,
    required this.startLatitude,
    required this.startLongitude,
    required this.createdAt,
  });

  factory FinderNote.fromJson(Map<String, dynamic> json) => FinderNote(
    id: json['id'] as String,
    statusCode: json['statusCode'] as String? ?? '',
    resultCode: json['resultCode'] as String?,
    note: json['note'] as String?,
    startLatitude: (json['startLatitude'] as num?)?.toDouble() ?? 0,
    startLongitude: (json['startLongitude'] as num?)?.toDouble() ?? 0,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.tryParse(json['createdAt'] as String),
  );
}
