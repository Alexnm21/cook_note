import '../enums/activity_level.dart';
import '../enums/gender.dart';
import '../enums/goal.dart';
import '../extensions/enum_extension.dart';
import '../extensions/map_extension.dart';

class Profile {
  final int id;
  final String userId;
  final String name;
  final int height;
  final int weight;
  final int? targetWeight;
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
      this.targetWeight,
      required this.gender,
      required this.age,
      required this.activityLevel,
      required this.goal});

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: (map['id'] as num?)?.toInt() ?? 0,
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      height: (map['height'] as num?)?.toInt() ?? 0,
      weight: (map['weight'] as num?)?.toInt() ?? 0,
      targetWeight: (map['target_weight'] as num?)?.toInt(),
      gender: EnumExtension.fromStringNullable(
              map['gender'] as String?, Gender.values) ??
          Gender.male,
      age: (map['age'] as num?)?.toInt() ?? 0,
      activityLevel: EnumExtension.fromStringNullable(
              map['activity_level'] as String?, ActivityLevel.values) ??
          ActivityLevel.sedentary,
      goal:
          EnumExtension.fromStringNullable(map['goal'] as String?, Goal.values) ??
              Goal.maintainWeight,
    );
  }
}

class ProfileDto {
  final int? id;
  final String? userId;
  final String? name;
  final int? height;
  final int? weight;
  final int? targetWeight;
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
      required this.goal,
      this.targetWeight});

  factory ProfileDto.fromProfile(Profile profile) {
    return ProfileDto(
      id: profile.id,
      userId: profile.userId,
      name: profile.name,
      height: profile.height,
      weight: profile.weight,
      targetWeight: profile.targetWeight,
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
      'target_weight': targetWeight,
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
    int? targetWeight,
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
      targetWeight: targetWeight ?? this.targetWeight,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }
}
