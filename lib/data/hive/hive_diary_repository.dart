import 'package:hive_flutter/hive_flutter.dart';

import '../../core/enums/occasion.dart';
import '../../core/models/daily_meal_entry.dart';
import '../../core/models/diary_day.dart';
import '../abstract/diary_repository.dart';

/// Implementation of the diary repository using Hive
class HiveDiaryRepository implements DiaryRepository {
  static const String _boxName = 'diary_box';
  Box? _box;

  /// Initializes the Hive box
  Future<void> init() async {
    _box ??= await Hive.openBox(_boxName);
  }

  /// Gets the key for a specific date (format: YYYY-MM-DD)
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Future<DiaryDay> saveDay(DiaryDay day) async {
    await init();
    final key = _getDateKey(day.date);
    await _box!.put(key, day.toMap());
    return day;
  }

  @override
  Future<DiaryDay> addMeal(DailyMealEntry meal, DateTime date) async {
    await init();
    final day = await getDay(date);
    if (day == null) throw Exception('Day not found');
    final updatedDay = day.addMeal(meal);
    return saveDay(updatedDay);
  }

  @override
  Future<DiaryDay?> getDay(DateTime date) async {
    await init();
    final key = _getDateKey(date);
    final data = _box!.get(key);

    if (data == null) return null;

    return DiaryDay.fromMap(Map<String, dynamic>.from(data));
  }

  @override
  Future<DiaryDay> removeMeal({
    required DateTime date,
    required Occasion occasion,
    required String recipeId,
  }) async {
    await init();

    final existingDay = await getDay(date);
    if (existingDay == null) throw Exception('Day not found');

    final updatedDay = existingDay.removeMeal(occasion, recipeId);
    await saveDay(updatedDay);
    return updatedDay;
  }

  @override
  Future<List<DiaryDay>> getAllDays() async {
    await init();
    final keys = _box!.keys.toList();
    final days = <DiaryDay>[];
    for (final key in keys) {
      final data = _box!.get(key);
      if (data == null) continue;
      days.add(DiaryDay.fromMap(Map<String, dynamic>.from(data)));
    }
    return days;
  }

  @override
  Future<void> deleteDay(DateTime date) async {
    await init();
    final key = _getDateKey(date);
    await _box!.delete(key);
  }

  @override
  Future<void> clearPreviousDays() async {
    await init();
    final days = await getAllDays();
    final now = DateTime.now();
    // Calculate the cutoff date: 5 days before today (at midnight)
    final today = DateTime(now.year, now.month, now.day);
    final fiveDaysAgo = today.subtract(const Duration(days: 5));

    for (final day in days) {
      // Normalize day.date to midnight for accurate comparison
      final dayDate = DateTime(day.date.year, day.date.month, day.date.day);
      // Delete all days that are before (not including) 5 days ago
      if (dayDate.isBefore(fiveDaysAgo)) {
        await deleteDay(day.date);
      }
    }
  }
}
