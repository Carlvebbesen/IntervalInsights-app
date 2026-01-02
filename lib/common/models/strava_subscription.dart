class StravaSubscription {
  final int id;

  StravaSubscription({required this.id});
  factory StravaSubscription.fromJson(Map<String, dynamic> json) {
    return StravaSubscription(id: json['id'] as int);
  }

  static List<StravaSubscription> fromList(List<dynamic> list) {
    return list
        .map(
          (item) => StravaSubscription.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
