import 'package:interval_insights_app/common/models/enums/interval_unit_enum.dart';
import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';

class DetectedStep {
  final int reps;
  final WorkType workType;
  final double workValue;
  final double? recoveryValue;
  final WorkType? recoveryType;

  DetectedStep({
    required this.reps,
    required this.workType,
    required this.workValue,
    this.recoveryValue,
    this.recoveryType,
  });

  factory DetectedStep.fromJson(Map<String, dynamic> json) {
    return DetectedStep(
      reps: json['reps'] as int,
      workType: WorkType.fromString(json['work_type'] as String),
      recoveryType: WorkType.fromStringOrnull(json['recovery_type'] as String?),
      workValue: (json['work_value'] as num).toDouble(),
      recoveryValue: (json['recovery_value'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'work_type': workType.name.toUpperCase(),
      if (recoveryType != null)
        'recovery_type': recoveryType?.name.toUpperCase(),
      'work_value': workValue,
      if (recoveryValue != null) 'recovery_value': recoveryValue,
    };
  }
}

class DetectedSet {
  final int setReps;
  final List<DetectedStep> steps;
  final double? setRecovery;

  DetectedSet({required this.setReps, required this.steps, this.setRecovery});

  factory DetectedSet.fromJson(Map<String, dynamic> json) {
    return DetectedSet(
      setReps: json['set_reps'] as int,
      steps: (json['steps'] as List)
          .map((e) => DetectedStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      setRecovery: (json['set_recovery'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'set_reps': setReps,
      'steps': steps.map((e) => e.toJson()).toList(),
      if (setRecovery != null) 'set_recovery': setRecovery,
    };
  }

  static List<DetectedSet> fromList(List<dynamic> list) {
    return list
        .map((item) => DetectedSet.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class WorkoutAnalysisOutput {
  final TrainingType trainingType;
  final double confidenceScore;
  final String? intervalsDescription;
  final List<DetectedSet> structure;

  WorkoutAnalysisOutput({
    required this.trainingType,
    required this.confidenceScore,
    this.intervalsDescription,
    required this.structure,
  });

  factory WorkoutAnalysisOutput.fromJson(Map<String, dynamic> json) {
    return WorkoutAnalysisOutput(
      trainingType:
          TrainingType.fromApiValue((json['training_type'] as String? ?? "")) ??
          TrainingType.other,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      intervalsDescription: json['intervals_description'] as String?,
      structure: json['structure'] != null
          ? DetectedSet.fromList(json['structure'] as List<dynamic>)
          : [],
    );
  }
}

class PendingActivity {
  final int id;
  final int stravaId;
  final String notes;
  final TrainingType? trainingType;
  final bool isCompleted;
  final bool isOnAnalyzeStep;
  final String? analysisStatus;
  final WorkoutAnalysisOutput? draftAnalysisResult;
  final String title;
  final double distance;
  final int movingTime;
  final String? description;
  final int? feeling;
  final bool indoor;

  PendingActivity({
    required this.id,
    required this.stravaId,
    required this.notes,
    required this.isCompleted,
    required this.isOnAnalyzeStep,
    required this.feeling,
    this.trainingType,
    this.analysisStatus,
    this.draftAnalysisResult,
    required this.title,
    required this.indoor,
    required this.distance,
    required this.movingTime,
    this.description,
  });

  PendingActivity copyWith({
    int? id,
    int? stravaId,
    String? notes,
    TrainingType? trainingType,
    bool? isCompleted,
    bool? isOnAnalyzeStep,
    String? analysisStatus,
    WorkoutAnalysisOutput? draftAnalysisResult,
    String? title,
    double? distance,
    int? movingTime,
    String? description,
    int? feeling,
    bool? indoor,
  }) {
    return PendingActivity(
      id: id ?? this.id,
      indoor: indoor ?? this.indoor,
      notes: notes ?? this.notes,
      stravaId: stravaId ?? this.stravaId,
      feeling: feeling ?? this.feeling,
      trainingType: trainingType ?? this.trainingType,
      isCompleted: isCompleted ?? this.isCompleted,
      analysisStatus: analysisStatus ?? this.analysisStatus,
      draftAnalysisResult: draftAnalysisResult ?? this.draftAnalysisResult,
      title: title ?? this.title,
      isOnAnalyzeStep: isOnAnalyzeStep ?? this.isOnAnalyzeStep,
      distance: distance ?? this.distance,
      movingTime: movingTime ?? this.movingTime,
      description: description ?? this.description,
    );
  }

  factory PendingActivity.fromJson(Map<String, dynamic> json) {
    final trainingType = TrainingType.fromApiValue(
      json['trainingType'] as String? ?? "",
    );
    return PendingActivity(
      id: json['id'] as int,
      stravaId: json['stravaId'] as int,
      feeling: json['feeling'] as int?,
      notes: json['notes'] as String? ?? "",
      indoor: json['indoor'] as bool,
      isCompleted: false,
      isOnAnalyzeStep:
          TrainingType.fromApiValue(json['trainingType'] as String? ?? "") !=
          null,
      trainingType: trainingType,
      analysisStatus: json['analysisStatus'] as String?,
      draftAnalysisResult: json['draftAnalysisResult'] != null
          ? WorkoutAnalysisOutput.fromJson(
              json['draftAnalysisResult'] as Map<String, dynamic>,
            )
          : null,
      title: json['title'] as String? ?? '',
      distance: (json['distance'] as num).toDouble(),
      movingTime: json['movingTime'] as int,
      description: json['description'] as String?,
    );
  }

  static List<PendingActivity> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => PendingActivity.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
