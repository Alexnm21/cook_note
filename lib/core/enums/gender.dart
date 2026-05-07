import 'package:easy_localization/easy_localization.dart';

enum Gender { male, female }

extension GenderExtension on Gender {
  String get stringValue => name.toLowerCase();

  static Gender fromString(String value) {
    return Gender.values.firstWhere((e) => e.name == value);
  }

  String get text => 'profile.gender.$name'.tr();
}
