import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';

class CompleteActivity {
  final int id;
  final String userId;
  final TrainingType trainingType;
  final int? intervalStructureId;
  final DateTime? analyzedAt;
  final String analysisStatus;
  // final Map<String, dynamic>? draftAnalysisResult; // JSON field
  // final String? analysisVersion;
  final int stravaActivityId;
  final String? gearId;
  final bool? hasHeartRate;
  final String title;
  final String? description;
  final String sportType;
  final String? deviceName;
  final double distance;
  final int movingTime;
  final int elapsedTime;
  final double? totalElevationGain;
  final double? averageSpeed;
  final double? averageHeartRate;
  final double? maxHeartRate;
  final DateTime startDateLocal;
  final int? feeling;
  final String? notes;
  final String? gearName;
  final DateTime? createdAt;
  final int? averageTmp;
  final bool indoor;

  const CompleteActivity({
    required this.id,
    required this.userId,
    required this.trainingType,
    this.intervalStructureId,
    this.analyzedAt,
    this.analysisStatus = 'pending',
    // this.draftAnalysisResult,
    // this.analysisVersion = 'v1.0',
    required this.stravaActivityId,
    this.gearId,
    this.hasHeartRate,
    required this.title,
    this.description,
    required this.sportType,
    this.deviceName,
    required this.distance,
    required this.movingTime,
    required this.elapsedTime,
    this.totalElevationGain,
    this.averageSpeed,
    this.averageHeartRate,
    this.maxHeartRate,
    required this.startDateLocal,
    this.feeling,
    this.notes,
    this.gearName,
    this.createdAt,
    this.averageTmp,
    required this.indoor,
  });

  // ---------------------------------------------------------------------------
  // CopyWith
  // ---------------------------------------------------------------------------
  CompleteActivity copyWith({
    int? id,
    String? userId,
    TrainingType? trainingType,
    int? intervalStructureId,
    DateTime? analyzedAt,
    String? analysisStatus,
    // Map<String, dynamic>? draftAnalysisResult,
    // String? analysisVersion,
    int? stravaActivityId,
    String? gearId,
    bool? hasHeartRate,
    String? title,
    String? description,
    String? sportType,
    String? deviceName,
    double? distance,
    int? movingTime,
    int? elapsedTime,
    double? totalElevationGain,
    double? averageSpeed,
    double? averageHeartRate,
    double? maxHeartRate,
    DateTime? startDateLocal,
    int? feeling,
    String? notes,
    String? gearName,
    DateTime? createdAt,
    int? averageTmp,
    bool? indoor,
  }) {
    return CompleteActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      trainingType: trainingType ?? this.trainingType,
      intervalStructureId: intervalStructureId ?? this.intervalStructureId,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      analysisStatus: analysisStatus ?? this.analysisStatus,
      // draftAnalysisResult: draftAnalysisResult ?? this.draftAnalysisResult,
      // analysisVersion: analysisVersion ?? this.analysisVersion,
      stravaActivityId: stravaActivityId ?? this.stravaActivityId,
      gearId: gearId ?? this.gearId,
      hasHeartRate: hasHeartRate ?? this.hasHeartRate,
      title: title ?? this.title,
      description: description ?? this.description,
      sportType: sportType ?? this.sportType,
      deviceName: deviceName ?? this.deviceName,
      distance: distance ?? this.distance,
      movingTime: movingTime ?? this.movingTime,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      totalElevationGain: totalElevationGain ?? this.totalElevationGain,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      averageHeartRate: averageHeartRate ?? this.averageHeartRate,
      maxHeartRate: maxHeartRate ?? this.maxHeartRate,
      startDateLocal: startDateLocal ?? this.startDateLocal,
      feeling: feeling ?? this.feeling,
      notes: notes ?? this.notes,
      gearName: gearName ?? this.gearName,
      createdAt: createdAt ?? this.createdAt,
      averageTmp: averageTmp ?? this.averageTmp,
      indoor: indoor ?? this.indoor,
    );
  }



  factory CompleteActivity.fromJson(Map<String, dynamic> map) {
    return CompleteActivity(
      id: (map['id'] as num).toInt(),
      userId: map['userId'] as String,
      trainingType: TrainingType.fromString(map['trainingType'] as String),
      intervalStructureId: (map['intervalStructureId'] as num?)?.toInt(),
      analyzedAt: map['analyzedAt'] != null
          ? DateTime.tryParse(map['analyzedAt'] as String)
          : null,
      analysisStatus: map['analysisStatus'] as String? ?? 'pending',
      // draftAnalysisResult: map['draft_analysis_result'] != null
      //     ? Map<String, dynamic>.from(map['draft_analysis_result'] as Map)
      //     : null,
      // analysisVersion: map['analysis_version'] as String? ?? 'v1.0',
      stravaActivityId: (map['stravaActivityId'] as num).toInt(),
      gearId: map['gearId'] as String?,
      hasHeartRate: map['hasHeartRate'] as bool?,
      title: map['title'] as String,
      description: map['description'] as String?,
      sportType: map['sportType'] as String,
      deviceName: map['deviceName'] as String?,
      distance: (map['distance'] as num).toDouble(),
      movingTime: (map['movingTime'] as num).toInt(),
      elapsedTime: (map['elapsedTime'] as num).toInt(),
      totalElevationGain: (map['totalElevationGain'] as num?)?.toDouble(),
      averageSpeed: (map['averageSpeed'] as num?)?.toDouble(),
      averageHeartRate: (map['averageHeartRate'] as num?)?.toDouble(),
      maxHeartRate: (map['maxHeartRate'] as num?)?.toDouble(),
      startDateLocal: DateTime.parse(map['startDateLocal'] as String),
      feeling: (map['feeling'] as num?)?.toInt(),
      notes: map['notes'] as String?,
      gearName: map['gearName'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      averageTmp: (map['averageTmp'] as num?)?.toInt(),
      indoor: map['indoor'] as bool? ?? false,
    );
  }
  static List<CompleteActivity> fromList(List<dynamic> list) {
    return list
        .map((item) => CompleteActivity.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
