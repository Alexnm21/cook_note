import '../../core/enums/supabase_names.dart';
import '../../core/models/weight_record.dart';
import '../abstract/weight_repository.dart';
import 'base_supabase_repository.dart';

class SupabaseWeightRepository extends BaseSupabaseRepository
    implements WeightRepository {
  static SupabaseWeightRepository? _instance;

  SupabaseWeightRepository._internal()
      : super(SupabaseNames.weightRecords.name);

  factory SupabaseWeightRepository.instance() {
    _instance ??= SupabaseWeightRepository._internal();
    return _instance!;
  }

  @override
  Future<List<WeightRecord>> getWeightRecords(String userId) async {
    final response = await supabase
        .from(tableName)
        .select()
        .eq('user_id', userId)
        .order('date', ascending: true);

    return response.map((json) => WeightRecord.fromMap(json)).toList();
  }

  @override
  Future<void> addWeightRecord(WeightRecord record, String userId) async {
    await supabase.from(tableName).upsert(
      {...record.toMap(), 'user_id': userId},
      onConflict: 'user_id,date',
    );
  }
}
