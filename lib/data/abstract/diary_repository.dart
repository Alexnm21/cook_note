import '../../core/enums/occasion.dart';
import '../../core/models/daily_meal_entry.dart';
import '../../core/models/diary_day.dart';

abstract class DiaryRepository {
  /// Saves or updates the meals for a specific day
  Future<DiaryDay> saveDay(DiaryDay day);

  Future<DiaryDay> addMeal(DailyMealEntry meal, DateTime date);

  /// Gets the meals for a specific day
  Future<DiaryDay?> getDay(DateTime date);

  /// Removes a meal from a specific day
  Future<DiaryDay> removeMeal({
    required DateTime date,
    required Occasion occasion,
    required String recipeId,
  });

  /// Gets all dates that have saved meals
  Future<List<DiaryDay>> getAllDays();

  /// Deletes all meals from a specific day
  Future<void> deleteDay(DateTime date);

  /// Clears previous days from the diary
  Future<void> clearPreviousDays();
}
