import '../enums/macros.dart';
import '../enums/occasion.dart';
import 'daily_meal_entry.dart';
import 'recipe.dart';

/// Represents all meals for a specific day
class DiaryDay {
  final DateTime date;
  final List<DailyMealEntry> meals;

  DiaryDay({
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

  /// Adds a meal to the diary day
  DiaryDay addMeal(DailyMealEntry meal) {
    final updatedMeals = [...meals, meal];

    return DiaryDay(date: date, meals: updatedMeals);
  }

  /// Removes a meal by recipe and occasion
  DiaryDay removeMeal(Occasion occasion, String recipeId) {
    final updatedMeals = meals
        .where(
          (m) => m.occasion != occasion && m.recipe.id != recipeId,
        )
        .toList();

    return DiaryDay(date: date, meals: updatedMeals);
  }

  /// Serializes the DiaryDay object to a map
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'meals': meals.map((m) => m.toMap()).toList(),
    };
  }

  /// Creates a DiaryDay object from a map
  factory DiaryDay.fromMap(Map<String, dynamic> map) {
    return DiaryDay(
      date: DateTime.parse(map['date'] as String),
      meals: (map['meals'] as List<dynamic>?)
              ?.map((m) => DailyMealEntry.fromMap(Map<String, dynamic>.from(m)))
              .toList() ??
          [],
    );
  }
}
