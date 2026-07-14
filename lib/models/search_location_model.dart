class SearchLocationModel {
  final String id;
  final String locationName;
  final double distance;
  final double latitude;
  final double longitude;
  final String foundLocation;

  SearchLocationModel({
    required this.id,
    required this.locationName,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.foundLocation,
  });
}
