import '../enums/activity_level.dart';
import '../enums/gender.dart';
import '../enums/goal.dart';
import '../extensions/map_extension.dart';

class Profile {
  final int id;
  final String userId;
  final String name;
  final int height;
  final int weight;
  final Gender gender;
  final int age;
  final ActivityLevel activityLevel;
  final Goal goal;

  Profile(
      {required this.id,
      required this.userId,
      required this.name,
      required this.height,
      required this.weight,
      required this.gender,
      required this.age,
      required this.activityLevel,
      required this.goal});

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      height: map['height'],
      weight: map['weight'],
      gender: GenderExtension.fromString(map['gender']),
      age: map['age'],
      activityLevel: ActivityLevelExtension.fromString(map['activity_level']),
      goal: GoalExtension.fromString(map['goal']),
    );
  }
}

class ProfileDto {
  final int? id;
  final String? userId;
  final String? name;
  final int? height;
  final int? weight;
  final Gender? gender;
  final int? age;
  final ActivityLevel? activityLevel;
  final Goal? goal;

  ProfileDto(
      {required this.id,
      required this.userId,
      required this.name,
      required this.height,
      required this.weight,
      required this.gender,
      required this.age,
      required this.activityLevel,
      required this.goal});

  factory ProfileDto.fromProfile(Profile profile) {
    return ProfileDto(
      id: profile.id,
      userId: profile.userId,
      name: profile.name,
      height: profile.height,
      weight: profile.weight,
      gender: profile.gender,
      age: profile.age,
      activityLevel: profile.activityLevel,
      goal: profile.goal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'height': height,
      'weight': weight,
      'gender': gender?.name,
      'age': age,
      'activity_level': activityLevel?.name,
      'goal': goal?.name,
    }.withoutNulls();
  }

  Profile toProfile() {
    return Profile.fromMap(toMap());
  }

  ProfileDto copyWith({
    int? id,
    String? userId,
    String? name,
    int? weight,
    Gender? gender,
    int? age,
    ActivityLevel? activityLevel,
    Goal? goal,
    int? height,
  }) {
    return ProfileDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }
}
