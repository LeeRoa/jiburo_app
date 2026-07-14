class AddPostState {
  // step 1
  final double? latitude;
  final double? longitude;
  final String? foundLocation;
  final String? locationName;

  // step 2
  final DateTime? lostDate;
  final String? name;
  final String? animalTypeCode;
  final String? breed;
  final int? age;
  final int? weight;
  final String? genderCode;
  final String? color;
  final int? reward;

  // step 3
  final List<String>? imageUrls;

  // step 4
  final String? title;
  final String? content;
  final String? categoryCode;
  final String? visibilityCode;

  // UI
  final List<bool> isDone;
  final bool isLoading;

  AddPostState({
    this.latitude,
    this.longitude,
    this.foundLocation,
    this.locationName,
    this.lostDate,
    this.name,
    this.animalTypeCode,
    this.breed,
    this.genderCode,
    this.color,
    this.age,
    this.weight,
    this.reward,
    this.imageUrls = const [],
    this.title,
    this.content,
    this.visibilityCode,
    this.categoryCode,
    this.isDone = const [false, false, false, false],
    this.isLoading = false,
  });

  AddPostState copyWith({
    double? latitude,
    double? longitude,
    String? foundLocation,
    String? locationName,
    String? title,
    String? animalTypeCode,
    String? breed,
    int? age,
    String? genderCode,
    String? color,
    int? reward,
    String? categoryCode,
    String? visibilityCode,
    String? lostDate,
    List<String>? imageUrls,
    String? content,
    required List<bool> isDone,
    bool? isActive,
    bool? isLoading,
  }) {
    return AddPostState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      foundLocation: foundLocation ?? this.foundLocation,
      locationName: locationName ?? this.locationName,
      title: title ?? this.title,
      animalTypeCode: animalTypeCode ?? this.animalTypeCode,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      genderCode: genderCode ?? this.genderCode,
      color: color ?? this.color,
      reward: reward ?? this.reward,
      categoryCode: categoryCode ?? this.categoryCode,
      visibilityCode: visibilityCode ?? this.visibilityCode,
      imageUrls: imageUrls ?? this.imageUrls,
      content: content ?? this.content,
      isDone: isDone,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isValid =>
      title != null &&
      content != null &&
      categoryCode != null &&
      animalTypeCode != null &&
      genderCode != null &&
      latitude != null &&
      longitude != null &&
      foundLocation != null &&
      lostDate != null;

  // 하나라도 값이 채워져 있으면 true
  bool get hasAnyInput =>
      title != null ||
      content != null ||
      categoryCode != null ||
      animalTypeCode != null ||
      breed != null ||
      genderCode != null ||
      color != null ||
      age != null ||
      lostDate != null ||
      reward != null ||
      foundLocation != null ||
      (imageUrls?.isNotEmpty ?? false);

  bool get stepOneInput =>
      latitude != null || longitude != null || foundLocation != null;

  bool get stepTwoInput =>
      categoryCode != null ||
      animalTypeCode != null ||
      breed != null ||
      genderCode != null ||
      color != null ||
      age != null ||
      lostDate != null ||
      reward != null;
}
