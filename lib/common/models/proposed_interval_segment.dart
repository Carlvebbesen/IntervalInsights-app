import 'package:interval_insights_app/common/models/enums/interval_unit_enum.dart';

class IntervalGroup {
  final int groupId;
  final List<ProposedIntervalSegment> items;
  final List<int> originalIndices;
  final num? restValue;
  bool isExpanded;

  IntervalGroup({
    required this.groupId,
    required this.items,
    required this.restValue,
    required this.originalIndices,
    this.isExpanded = false,
  });

  String get rangeText => originalIndices.length > 1
      ? "${originalIndices.first + 1}-${originalIndices.last + 1}"
      : "${originalIndices.first + 1}";

  bool get hasMultipleItems => items.length > 1;
  bool get hasSamePace {
    if (items.isEmpty) return true;
    final firstPace = items.first.proposedPace;
    return items.every((i) => i.proposedPace == firstPace);
  }

  IntervalGroup copyWith({
    int? groupId,
    List<ProposedIntervalSegment>? items,
    List<int>? originalIndices,
    num? restValue,
    bool? isExpanded,
  }) {
    return IntervalGroup(
      groupId: groupId ?? this.groupId,
      items: items ?? this.items,
      restValue: restValue ?? this.restValue,
      originalIndices: originalIndices ?? this.originalIndices,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "groupId": groupId,
      "items": items.map((item) => item.toJson()).toList(),
      "restValue": restValue,
    };
  }

  double get minPace {
    final paces = items.map((i) => i.proposedPace).toList();
    return paces.isEmpty ? 4.16 : paces.reduce((a, b) => a < b ? a : b);
  }

  double get maxPace {
    final paces = items.map((i) => i.proposedPace).toList();
    return paces.isEmpty ? 4.16 : paces.reduce((a, b) => a > b ? a : b);
  }
}

class ProposedIntervalSegment {
  final double targetValue;
  final IntervalUnit unit;
  final double proposedPace;

  ProposedIntervalSegment({
    required this.targetValue,
    required this.unit,
    required this.proposedPace,
  });
  factory ProposedIntervalSegment.fromJson(Map<String, dynamic> json) {
    return ProposedIntervalSegment(
      targetValue: (json['targetValue'] as num).toDouble(),
      unit: IntervalUnit.fromString(json['unit'] as String),
      proposedPace: json['proposedPace'] != null
          ? (json['proposedPace'] as num).toDouble()
          : 4.16,
    );
  }
  ProposedIntervalSegment copyWith({
    double? targetValue,
    IntervalUnit? unit,
    double? proposedPace,
    String? method,
  }) {
    return ProposedIntervalSegment(
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      proposedPace: proposedPace ?? this.proposedPace,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'targetValue': targetValue,
      'unit': unit.toString().split('.').last,
      'proposedPace': proposedPace,
    };
  }

  static List<ProposedIntervalSegment> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => ProposedIntervalSegment.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
