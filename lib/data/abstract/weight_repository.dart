import '../../core/models/weight_record.dart';

abstract class WeightRepository {
  Future<List<WeightRecord>> getWeightRecords(String userId);
  Future<void> addWeightRecord(WeightRecord record, String userId);
}