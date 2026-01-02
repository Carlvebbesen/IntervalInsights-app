import 'package:json_annotation/json_annotation.dart';

part 'summary_activity.g.dart';

@JsonSerializable()
class SummaryActivity {
  final int id;
  @JsonKey(name: 'resource_state')
  final int resourceState;
  @JsonKey(name: 'external_id')
  final String? externalId;
  @JsonKey(name: 'upload_id')
  final int? uploadId;
  final MetaAthlete athlete;
  final String name;
  final double distance;
  @JsonKey(name: 'moving_time')
  final int movingTime;
  @JsonKey(name: 'elapsed_time')
  final int elapsedTime;
  @JsonKey(name: 'total_elevation_gain')
  final double totalElevationGain;
  final String type;
  @JsonKey(name: 'sport_type')
  final String sportType;
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @JsonKey(name: 'start_date_local')
  final DateTime startDateLocal;
  final String timezone;
  @JsonKey(name: 'utc_offset')
  final double utcOffset;
  @JsonKey(name: 'start_latlng')
  final List<double>? startLatlng;
  @JsonKey(name: 'end_latlng')
  final List<double>? endLatlng;
  @JsonKey(name: 'location_city')
  final String? locationCity;
  @JsonKey(name: 'location_state')
  final String? locationState;
  @JsonKey(name: 'location_country')
  final String? locationCountry;
  @JsonKey(name: 'achievement_count')
  final int achievementCount;
  @JsonKey(name: 'kudos_count')
  final int kudosCount;
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @JsonKey(name: 'athlete_count')
  final int athleteCount;
  @JsonKey(name: 'photo_count')
  final int photoCount;
  final PolylineMap map;
  final bool trainer;
  final bool commute;
  final bool manual;
  final bool private;
  final bool flagged;
  @JsonKey(name: 'gear_id')
  final String? gearId;
  @JsonKey(name: 'average_speed')
  final double averageSpeed;
  @JsonKey(name: 'max_speed')
  final double maxSpeed;
  @JsonKey(name: 'has_heartrate')
  final bool hasHeartrate;
  @JsonKey(name: 'average_heartrate')
  final double? averageHeartrate;
  @JsonKey(name: 'max_heartrate')
  final double? maxHeartrate;
  @JsonKey(name: 'elev_high')
  final double? elevHigh;
  @JsonKey(name: 'elev_low')
  final double? elevLow;
  @JsonKey(name: 'pr_count')
  final int prCount;

  SummaryActivity({
    required this.id,
    required this.resourceState,
    this.externalId,
    this.uploadId,
    required this.athlete,
    required this.name,
    required this.distance,
    required this.movingTime,
    required this.elapsedTime,
    required this.totalElevationGain,
    required this.type,
    required this.sportType,
    required this.startDate,
    required this.startDateLocal,
    required this.timezone,
    required this.utcOffset,
    this.startLatlng,
    this.endLatlng,
    this.locationCity,
    this.locationState,
    this.locationCountry,
    required this.achievementCount,
    required this.kudosCount,
    required this.commentCount,
    required this.athleteCount,
    required this.photoCount,
    required this.map,
    required this.trainer,
    required this.commute,
    required this.manual,
    required this.private,
    required this.flagged,
    this.gearId,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.hasHeartrate,
    this.averageHeartrate,
    this.maxHeartrate,
    this.elevHigh,
    this.elevLow,
    required this.prCount,
  });

  factory SummaryActivity.fromJson(Map<String, dynamic> json) =>
      _$SummaryActivityFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryActivityToJson(this);

  static List<SummaryActivity> fromList(List<dynamic> list) {
    return list
        .map((item) => SummaryActivity.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

@JsonSerializable()
class MetaAthlete {
  final int id;
  @JsonKey(name: 'resource_state')
  final int resourceState;

  MetaAthlete({required this.id, required this.resourceState});

  factory MetaAthlete.fromJson(Map<String, dynamic> json) =>
      _$MetaAthleteFromJson(json);
  Map<String, dynamic> toJson() => _$MetaAthleteToJson(this);
}

@JsonSerializable()
class PolylineMap {
  final String id;
  @JsonKey(name: 'summary_polyline')
  final String? summaryPolyline;
  @JsonKey(name: 'resource_state')
  final int resourceState;

  PolylineMap({
    required this.id,
    this.summaryPolyline,
    required this.resourceState,
  });

  factory PolylineMap.fromJson(Map<String, dynamic> json) =>
      _$PolylineMapFromJson(json);
  Map<String, dynamic> toJson() => _$PolylineMapToJson(this);
}
