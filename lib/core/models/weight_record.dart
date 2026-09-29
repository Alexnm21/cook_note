class WeightRecord {
  final String? id;
  final double weightKg;
  final DateTime date;

  WeightRecord({
    this.id,
    required this.weightKg,
    required this.date,
  });

  factory WeightRecord.fromMap(Map<String, dynamic> map) {
    return WeightRecord(
      id: map['id'],
      weightKg: (map['weight_kg'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'weight_kg': weightKg,
      'date': dateKey,
    };
  }

  String get dateKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}