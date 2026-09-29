import '../../core/enums/occasion.dart';
import '../../core/models/daily_meal_entry.dart';
import '../../core/models/diary_entry.dart';

abstract class DiaryRepository {
  /// Saves or updates the meals for a specific day
  Future<DiaryEntry> saveDay(DiaryEntry day, String userId);

  Future<DiaryEntry> addMeal(DailyMealEntry meal, DateTime date, String userId);

  /// Gets the meals for a specific day
  Future<DiaryEntry?> getDay(DateTime date, String userId);

  /// Removes a meal from a specific day
  Future<DiaryEntry> removeMeal({
    required DateTime date,
    required Occasion occasion,
    required String recipeId,
    required String userId,
  });

  /// Gets all dates that have saved meals
  Future<List<DiaryEntry>> getAllDays(String userId);

  /// Deletes all meals from a specific day
  Future<void> deleteDay(DateTime date, String userId);

  /// Clears previous days from the diary
  Future<void> clearPreviousDays(String userId);
}