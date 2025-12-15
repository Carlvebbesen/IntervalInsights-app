import 'package:json_annotation/json_annotation.dart';

part 'athlete.g.dart';

@JsonSerializable()
class Athlete {
  final int id;
  @JsonKey(name: 'username')
  final String? userName;
  @JsonKey(name: 'resource_state')
  final int resourceState;
  @JsonKey(name: 'firstname')
  final String firstName;
  @JsonKey(name: 'lastname')
  final String lastName;
  final String? bio;
  final String? city;
  final String? state;
  final String? country;
  final String? sex;
  final bool premium;
  final bool summit;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'badge_type_id')
  final int badgeTypeId;
  final double? weight;
  @JsonKey(name: 'profile_medium')
  final String profileMedium;
  final String profile;
  final String? friend;
  final String? follower;

  // 1. Constructor
  const Athlete({
    required this.id,
    required this.userName,
    required this.resourceState,
    required this.firstName,
    required this.lastName,
    required this.bio,
    required this.city,
    required this.state,
    required this.country,
    required this.sex,
    required this.premium,
    required this.summit,
    required this.createdAt,
    required this.updatedAt,
    required this.badgeTypeId,
    required this.weight,
    required this.profileMedium,
    required this.profile,
    required this.friend,
    required this.follower,
  });
  factory Athlete.fromJson(Map<String, dynamic> json) =>
      _$AthleteFromJson(json);

  Map<String, dynamic> toJson() => _$AthleteToJson(this);

  Athlete copyWith({
    int? id,
    String? userName,
    int? resourceState,
    String? firstName,
    String? lastName,
    String? bio,
    String? city,
    String? state,
    String? country,
    String? sex,
    bool? premium,
    bool? summit,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? badgeTypeId,
    double? weight,
    String? profileMedium,
    String? profile,
    String? friend,
    String? follower,
  }) {
    return Athlete(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      resourceState: resourceState ?? this.resourceState,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      sex: sex ?? this.sex,
      premium: premium ?? this.premium,
      summit: summit ?? this.summit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      badgeTypeId: badgeTypeId ?? this.badgeTypeId,
      weight: weight ?? this.weight,
      profileMedium: profileMedium ?? this.profileMedium,
      profile: profile ?? this.profile,
      friend: friend ?? this.friend,
      follower: follower ?? this.follower,
    );
  }
}
