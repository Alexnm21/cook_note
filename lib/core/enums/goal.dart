import 'package:easy_localization/easy_localization.dart';

enum Goal {
  loseWeight,
  loseWeightHealthy,
  maintainWeight,
  gainWeightHealthy,
  gainWeight,
}

extension GoalExtension on Goal {
  static Goal fromString(String value) {
    return Goal.values.firstWhere((e) => e.name == value);
  }

  String get text => 'profile.goal.$name'.tr();
}
