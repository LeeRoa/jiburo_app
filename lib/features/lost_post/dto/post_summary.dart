import 'package:jiburo_app/core/utils/formatters.dart';
import 'package:jiburo_app/features/lost_post/providers/location_state.dart';

/// 게시글 목록·카드용 요약 (GET /posts/{id}, /users/me/posts 응답 일부)
class PostSummary {
  final String id;
  final String title;
  final String foundLocation;
  final double? latitude;
  final double? longitude;
  final int? reward; // 단위: 원 (표시는 formatRewardParts)
  final DateTime? createdAt;
  final String? imageUrl;
  final String statusCode;

  const PostSummary({
    required this.id,
    required this.title,
    required this.foundLocation,
    this.latitude,
    this.longitude,
    this.reward,
    this.createdAt,
    this.imageUrl,
    this.statusCode = '',
  });

  factory PostSummary.fromJson(Map<String, dynamic> json) => PostSummary(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    foundLocation: json['foundLocation'] as String? ?? '',
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    reward: (json['reward'] as num?)?.toInt(),
    createdAt: _parseTime(json['createdAt']),
    imageUrl: json['imageUrl'] as String?,
  );
}

extension PostSummaryDistance on PostSummary {
  /// 내 위치에서 게시글까지 거리(km). 내 위치나 게시글 좌표를 모르면 null
  double? get distanceFromMeKm {
    final lat = latitude;
    final lng = longitude;
    final myLat = LocationState.lat;
    final myLng = LocationState.lng;
    if (lat == null || lng == null || myLat == null || myLng == null) {
      return null;
    }
    return distanceKm(myLat, myLng, lat, lng);
  }

  /// 내 위치에서 5km 이내
  String? get nearbyLabel {
    final km = distanceFromMeKm;
    return km == null ? null : formatNearby(km);
  }
}

DateTime? _parseTime(Object? v) =>
    v == null ? null : DateTime.tryParse(v as String);
