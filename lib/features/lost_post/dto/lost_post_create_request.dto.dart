import 'package:json_annotation/json_annotation.dart';

part 'lost_post_create_request.dto.g.dart';

@JsonSerializable()
class LostPostCreateRequest {
  final String title;
  final String content;
  final String categoryCode; // common codes
  final String animalTypeCode; // common codes
  final String? breed;
  final String genderCode; // common codes
  final String? color;
  final int? age;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;
  final String foundLocation;

  @JsonKey(fromJson: _dateFromString, toJson: _dateToString)
  final DateTime lostDate;

  final int? reward;
  final String visibilityCode; // common codes

  LostPostCreateRequest({
    required this.title,
    required this.content,
    required this.categoryCode,
    required this.animalTypeCode,
    required this.breed,
    required this.genderCode,
    required this.color,
    required this.age,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
    required this.foundLocation,
    required this.lostDate,
    required this.reward,
    required this.visibilityCode,
  });

  factory LostPostCreateRequest.fromJson(Map<String, dynamic> json) =>
      _$LostPostCreateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LostPostCreateRequestToJson(this);

  static DateTime _dateFromString(String date) => DateTime.parse(date);
  static String _dateToString(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
