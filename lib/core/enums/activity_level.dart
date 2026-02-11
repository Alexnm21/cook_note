import 'package:easy_localization/easy_localization.dart';

enum ActivityLevel { sedentary, light, moderate, active, veryActive }

extension ActivityLevelExtension on ActivityLevel {
  static ActivityLevel fromString(String value) {
    return ActivityLevel.values.firstWhere((e) => e.name == value);
  }

  String get text => 'profile.activity_level.$name'.tr();
}
