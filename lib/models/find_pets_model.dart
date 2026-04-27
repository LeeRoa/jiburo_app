class FindPetsModel {
  final String id;
  final String name;
  final String breeds;
  final String missingSpot;
  final String area;
  final String reward;
  final String time;
  final String imgPath;
  final bool isLike;

  FindPetsModel({
    required this.id,
    required this.name,
    required this.breeds,
    required this.missingSpot,
    required this.area,
    required this.reward,
    required this.time,
    required this.imgPath,
    required this.isLike,
  });
}
