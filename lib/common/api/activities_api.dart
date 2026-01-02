import 'package:interval_insights_app/common/api/api.dart';
import 'package:interval_insights_app/common/models/complete_activity.dart';
import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';

class ActivitiesResponse {
  final List<CompleteActivity> data;
  final int page;
  final int pageSize;

  ActivitiesResponse({
    required this.data,
    required this.page,
    required this.pageSize,
  });

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return ActivitiesResponse(
      data: CompleteActivity.fromList(json["data"] as List<dynamic>),
      page: json['meta']['page'] as int,
      pageSize: json['meta']['pageSize'] as int,
    );
  }
}

class ActivitiesApi {
  final Api _api = Api();

  Future<ActivitiesResponse> getActivities({
    int page = 1,
    String? search,
    TrainingType? trainingType,
    double? minDistanceMeters,
  }) async {
    try {
      final queryParams = <String, String>{'page': page.toString()};
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (trainingType != null) {
        queryParams['trainingType'] = trainingType.apiValue;
      }
      if (minDistanceMeters != null) {
        queryParams['distance'] = minDistanceMeters.toString();
      }
      final response = await _api.get(
        '/activity',
        queryParameters: queryParams,
      );
      return ActivitiesResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return ActivitiesResponse(data: [], page: page, pageSize: 1);
    }
  }

  Future<void> update(
    int activityId, {
    TrainingType? trainingType,
    String? comment,
    int? feeling,
  }) async {
    await _api.post(
      '/activity/update',
      body: {
        "id": activityId,
        "trainingType": trainingType?.apiValue,
        "notes": comment,
        "feeling": feeling,
      },
    );
  }
}
