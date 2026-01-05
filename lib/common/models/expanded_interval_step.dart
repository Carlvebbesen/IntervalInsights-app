import 'dart:ui';

import 'package:interval_insights_app/common/models/enums/interval_unit_enum.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';

class ExpandedIntervalStep {
  final WorkType workType;
  final WorkType? recoveryType;
  final int? recoveryValue;
  final int workValue;
  final num targetPace;
  final IntervalUnit unit;
  final IntervalUnit? recoveryUnit;

  ExpandedIntervalStep({
    required this.workType,
    required this.workValue,
    required this.unit,
    required this.targetPace,
    this.recoveryValue,
    this.recoveryType,
    this.recoveryUnit,
  });
  ExpandedIntervalStep copyWith({
    WorkType? workType,
    int? workValue,
    int? recoveryValue,
    double? targetPace,
    IntervalUnit? unit,
    IntervalUnit? recoveryUnit,
    WorkType? recoveryType,
  }) {
    return ExpandedIntervalStep(
      workType: workType ?? this.workType,
      workValue: workValue ?? this.workValue,
      recoveryValue: recoveryValue ?? this.recoveryValue,
      targetPace: targetPace ?? this.targetPace,
      unit: unit ?? this.unit,
      recoveryUnit: recoveryUnit ?? this.recoveryUnit,
      recoveryType: recoveryType ?? this.recoveryType,
    );
  }

  factory ExpandedIntervalStep.fromJson(Map<String, dynamic> json) {
    final workType = WorkType.fromString(json['work_type'] as String);
    final recoveryType = WorkType.fromStringOrnull(
      json['recovery_type'] as String?,
    );
    return ExpandedIntervalStep(
      workType: workType,
      workValue: json['work_value'] as int,
      recoveryValue: json['recovery_value'] as int?,
      targetPace: json['target_pace'] != null
          ? (json['target_pace'] as num).toDouble()
          : 4.16,
      unit: workType == WorkType.distance ? IntervalUnit.m : IntervalUnit.sec,
      recoveryType: recoveryType,
      recoveryUnit: recoveryType == null
          ? null
          : recoveryType == WorkType.distance
          ? IntervalUnit.m
          : IntervalUnit.sec,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'work_type': workType.name.toUpperCase(),
      'work_value': workValue,
      if (recoveryValue != null) 'recovery_value': recoveryValue,
      if (recoveryType != null)
        'recovery_type': recoveryType?.name.toUpperCase(),
      'target_pace': targetPace,
    };
  }
}

class ExpandedIntervalSet {
  final int? setRecovery;
  final bool expanded;
  final List<ExpandedIntervalStep> steps;
  final String originalSetId;
  final Color setColor;
  final List<int> originalIndices;

  ExpandedIntervalSet({
    this.setRecovery,
    this.expanded = false,
    required this.steps,
    required this.originalSetId,
    required this.setColor,
    required this.originalIndices,
  });

  String get rangeText => originalIndices.length > 1
      ? "${originalIndices.first + 1}-${originalIndices.last + 1}"
      : "${originalIndices.first + 1}";

  bool get hasMultipleItems => steps.length > 1;

  bool get hasSamePace {
    if (steps.isEmpty) return true;
    final firstPace = steps.first.targetPace;
    return steps.every((s) => s.targetPace == firstPace);
  }

  double get minPace {
    final paces = steps.map((s) => s.targetPace).toList();
    return paces.isEmpty
        ? 4.16
        : paces.reduce((a, b) => a < b ? a : b).toDouble();
  }

  double get maxPace {
    final paces = steps.map((s) => s.targetPace).toList();
    return paces.isEmpty
        ? 4.16
        : paces.reduce((a, b) => a > b ? a : b).toDouble();
  }

  ExpandedIntervalSet copyWith({
    int? setRecovery,
    List<ExpandedIntervalStep>? steps,
    String? originalSetId,
    Color? setColor,
    List<int>? originalIndices,
    bool? expanded,
  }) {
    return ExpandedIntervalSet(
      setRecovery: setRecovery ?? this.setRecovery,
      expanded: expanded ?? this.expanded,
      steps: steps ?? this.steps,
      originalSetId: originalSetId ?? this.originalSetId,
      setColor: setColor ?? this.setColor,
      originalIndices: originalIndices ?? this.originalIndices,
    );
  }

  static List<ExpandedIntervalSet> fromJsonList(List<dynamic> jsonList) {
    final setColors = [
      AppColors.surfaceLight,
      AppColors.surfaceCard,
      AppColors.orange,
      AppColors.accent,
    ];

    int currentGlobalIndex = 0;

    return jsonList.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> data = entry.value as Map<String, dynamic>;

      final stepsData = data['steps'] as List? ?? [];
      final int stepCount = stepsData.length;

      final indices = List.generate(stepCount, (i) => currentGlobalIndex + i);

      currentGlobalIndex += stepCount;

      return ExpandedIntervalSet.fromJson(
        data,
        id: 'Set ${index + 1}',
        color: setColors[index % setColors.length],
        indices: indices,
      );
    }).toList();
  }

  factory ExpandedIntervalSet.fromJson(
    Map<String, dynamic> json, {
    String? id,
    Color? color,
    List<int>? indices,
  }) {
    return ExpandedIntervalSet(
      originalSetId: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      setColor: color ?? AppColors.accent,
      setRecovery: json['set_recovery'] as int?,
      originalIndices: indices ?? [],
      steps: (json['steps'] as List)
          .map((e) => ExpandedIntervalStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'set_recovery': setRecovery,
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}
