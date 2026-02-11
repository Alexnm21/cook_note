import 'package:easy_localization/easy_localization.dart';

enum Unit {
  gram,
  milliliter,
  tablespoon,
  piece;

  String get text => 'units.$name'.tr();
  String get shortText => 'units.short.$name'.tr();
}

extension UnitExtension on Unit {
  static Unit? fromString(String? value) {
    if (value == null) return null;
    return Unit.values.firstWhere((e) => e.name == value);
  }
}
