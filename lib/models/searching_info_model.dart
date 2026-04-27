import 'package:jiburo_app/models/map_position_model.dart';

enum SearchType { search, sighting }

class SearchingInfoModel {
  final String id;
  final SearchType type;
  final String memo;
  final MapPositionModel position;
  final String date;

  SearchingInfoModel({
    required this.id,
    required this.type,
    required this.memo,
    required this.position,
    required this.date,
  });
}
