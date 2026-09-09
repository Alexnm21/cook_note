import '../../core/enums/occasion.dart';
import '../../core/enums/supabase_names.dart';
import '../../core/models/daily_meal_entry.dart';
import '../../core/models/diary_entry.dart';
import '../abstract/diary_repository.dart';
import 'base_supabase_repository.dart';

class SupabaseDiaryRepository extends BaseSupabaseRepository
    implements DiaryRepository {
  static SupabaseDiaryRepository? _instance;

  SupabaseDiaryRepository._internal()
      : super(SupabaseNames.diaryEntries.name);

  factory SupabaseDiaryRepository.instance() {
    _instance ??= SupabaseDiaryRepository._internal();
    return _instance!;
  }

  @override
  Future<DiaryEntry> saveDay(DiaryEntry day, String userId) async {
    final data = {
      'user_id': userId,
      'date': _dateKey(day.date),
      'meals': day.meals.map((m) => m.toMap()).toList(),
    };

    await supabase.from(tableName).upsert(data, onConflict: 'user_id,date');
    return day;
  }

  @override
  Future<DiaryEntry> addMeal(
    DailyMealEntry meal,
    DateTime date,
    String userId,
  ) async {
    final day = await getDay(date, userId);
    final updatedDay = (day ?? DiaryEntry(date: date)).addMeal(meal);
    return saveDay(updatedDay, userId);
  }

  @override
  Future<DiaryEntry?> getDay(DateTime date, String userId) async {
    final response = await supabase
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .eq('date', _dateKey(date))
        .maybeSingle();

    if (response == null) return null;
    return DiaryEntry.fromMap(response);
  }

  @override
  Future<DiaryEntry> removeMeal({
    required DateTime date,
    required Occasion occasion,
    required String recipeId,
    required String userId,
  }) async {
    final existingDay = await getDay(date, userId);
    if (existingDay == null) throw Exception('Day not found');

    final updatedDay = existingDay.removeMeal(occasion, recipeId);
    return saveDay(updatedDay, userId);
  }

  @override
  Future<List<DiaryEntry>> getAllDays(String userId) async {
    final response = await supabase
        .from(tableName)
        .select()
        .eq('user_id', userId);

    return response
        .map((json) => DiaryEntry.fromMap(json))
        .toList();
  }

  @override
  Future<void> deleteDay(DateTime date, String userId) async {
    await supabase
        .from(tableName)
        .delete()
        .eq('user_id', userId)
        .eq('date', _dateKey(date));
  }

  @override
  Future<void> clearPreviousDays(String userId) async {
    final days = await getAllDays(userId);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fiveDaysAgo = today.subtract(const Duration(days: 5));

    for (final day in days) {
      final dayDate = DateTime(day.date.year, day.date.month, day.date.day);
      if (dayDate.isBefore(fiveDaysAgo)) {
        await deleteDay(day.date, userId);
      }
    }
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}