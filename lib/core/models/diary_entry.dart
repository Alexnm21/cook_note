import '../enums/macros.dart';
import '../enums/occasion.dart';
import 'daily_meal_entry.dart';
import 'recipe.dart';

/// Represents all meals for a specific day
class DiaryEntry {
  final DateTime date;
  final List<DailyMealEntry> meals;

  DiaryEntry({
    required this.date,
    this.meals = const [],
  });

  /// Gets the recipe for a specific occasion
  Recipe? getRecipeForOccasion(String occasionName) {
    try {
      return meals
          .firstWhere(
            (meal) => meal.occasion.name == occasionName,
          )
          .recipe;
    } catch (e) {
      return null;
    }
  }

  double getCalories() {
    return meals.fold(0, (sum, meal) => sum + meal.recipe.calories);
  }

  double getProtein() {
    return meals.fold(0, (sum, meal) => sum + meal.recipe.protein);
  }

  double getCarbs() {
    return meals.fold(0, (sum, meal) => sum + meal.recipe.carbs);
  }

  double getFat() {
    return meals.fold(0, (sum, meal) => sum + meal.recipe.fat);
  }

  double getMacro(Macros m) {
    double value = 0;
    switch (m) {
      case Macros.calories:
        value = getCalories();
        break;
      case Macros.protein:
        value = getProtein();
        break;
      case Macros.carbs:
        value = getCarbs();
        break;
      case Macros.fat:
        value = getFat();
        break;
    }
    return value;
  }

  /// Adds a meal to the diary entry
  DiaryEntry addMeal(DailyMealEntry meal) {
    final updatedMeals = [...meals, meal];

    return DiaryEntry(date: date, meals: updatedMeals);
  }

  /// Removes a meal by recipe and occasion
  DiaryEntry removeMeal(Occasion occasion, String recipeId) {
    final updatedMeals = meals
        .where(
          (m) => m.occasion != occasion || m.recipe.id != recipeId,
        )
        .toList();

    return DiaryEntry(date: date, meals: updatedMeals);
  }

  /// Serializes the DiaryEntry object to a map
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'meals': meals.map((m) => m.toMap()).toList(),
    };
  }

  /// Creates a DiaryEntry object from a map
  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      date: DateTime.parse(map['date'] as String),
      meals: (map['meals'] as List<dynamic>?)
              ?.map((m) => DailyMealEntry.fromMap(Map<String, dynamic>.from(m)))
              .toList() ??
          [],
    );
  }
}