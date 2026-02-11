import '../enums/occasion.dart';
import 'recipe.dart';

/// Representa una receta consumida en una ocasión específica de un día
class DailyMealEntry {
  final Occasion occasion;
  final Recipe recipe;

  DailyMealEntry({
    required this.occasion,
    required this.recipe,
  });

  Map<String, dynamic> toMap() {
    return {
      'occasion': occasion.name,
      'recipe': recipe.toMap(),
    };
  }

  factory DailyMealEntry.fromMap(Map<String, dynamic> map) {
    return DailyMealEntry(
      occasion: Occasion.values.firstWhere(
        (o) => o.name == map['occasion'],
      ),
      recipe: Recipe.fromMap(Map<String, dynamic>.from(map['recipe'])),
    );
  }
}
