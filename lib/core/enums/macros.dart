import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

enum Macros {
  calories,
  protein,
  carbs,
  fat;

  Color get color => switch (this) {
        Macros.calories => AppColors.calories,
        Macros.protein => AppColors.protein,
        Macros.carbs => AppColors.carbs,
        Macros.fat => AppColors.fat,
      };

  IconData get icon => switch (this) {
        Macros.calories => Icons.local_fire_department,
        Macros.protein => Icons.fitness_center,
        Macros.carbs => Icons.grain,
        Macros.fat => Icons.opacity,
      };

  String get text => 'macros.$name'.tr();
}

extension MacrosExtension on Macros {
  static Macros fromString(String value) {
    return Macros.values.firstWhere((m) => m.name == value);
  }
}
