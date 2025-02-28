import 'package:easy_localization/easy_localization.dart';

enum Unit {
  cup,
  tablespoon,
  gram,
  milliliter;

  String get text => 'units.$name'.tr();
}
