// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_post_create_request.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LostPostCreateRequest _$LostPostCreateRequestFromJson(
  Map<String, dynamic> json,
) => LostPostCreateRequest(
  title: json['title'] as String,
  content: json['content'] as String,
  categoryCode: json['categoryCode'] as String,
  animalTypeCode: json['animalTypeCode'] as String,
  breed: json['breed'] as String?,
  genderCode: json['genderCode'] as String,
  color: json['color'] as String?,
  age: (json['age'] as num?)?.toInt(),
  imageUrls: (json['imageUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  foundLocation: json['foundLocation'] as String,
  lostDate: LostPostCreateRequest._dateFromString(json['lostDate'] as String),
  reward: (json['reward'] as num?)?.toInt(),
  visibilityCode: json['visibilityCode'] as String,
);

Map<String, dynamic> _$LostPostCreateRequestToJson(
  LostPostCreateRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'content': instance.content,
  'categoryCode': instance.categoryCode,
  'animalTypeCode': instance.animalTypeCode,
  'breed': instance.breed,
  'genderCode': instance.genderCode,
  'color': instance.color,
  'age': instance.age,
  'imageUrls': instance.imageUrls,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'foundLocation': instance.foundLocation,
  'lostDate': LostPostCreateRequest._dateToString(instance.lostDate),
  'reward': instance.reward,
  'visibilityCode': instance.visibilityCode,
};
