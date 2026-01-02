import 'package:json_annotation/json_annotation.dart';

part 'sync_result.g.dart';

@JsonSerializable()
class SyncResult {
  final int id;
  final String status;
  final Object? error;

  SyncResult({required this.id, required this.status, this.error});
  bool get isSuccess => status == 'success';

  static List<SyncResult> fromList(List<dynamic> list) {
    return list
        .map((item) => SyncResult.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  factory SyncResult.fromJson(Map<String, dynamic> json) =>
      _$SyncResultFromJson(json);
  Map<String, dynamic> toJson() => _$SyncResultToJson(this);
}
