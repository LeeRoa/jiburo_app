import 'package:json_annotation/json_annotation.dart';

part 'api_response.dto.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponseDto<T> {
  final bool success;
  final int status;
  final String? errorCode;
  final String? message;
  final T? data;

  ApiResponseDto({
    required this.success,
    required this.status,
    this.errorCode,
    this.message,
    this.data,
  });

  factory ApiResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseDtoFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseDtoToJson(this, toJsonT);
}
