part of 'weight_bloc.dart';

enum WeightRange {
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
  all,
}

class WeightState {
  final bool loading;
  final bool adding;
  final List<WeightRecord> records;
  final WeightRange range;
  final int? targetWeight;

  WeightState({
    this.loading = true,
    this.adding = false,
    this.records = const [],
    this.range = WeightRange.oneMonth,
    this.targetWeight,
  });

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  List<WeightRecord> get recordsInRange {
    final today = _today;
    final start = switch (range) {
      WeightRange.oneMonth => DateTime(today.year, today.month - 1, today.day),
      WeightRange.threeMonths => DateTime(today.year, today.month - 3, today.day),
      WeightRange.sixMonths => DateTime(today.year, today.month - 6, today.day),
      WeightRange.oneYear => DateTime(today.year - 1, today.month, today.day),
      WeightRange.all => null,
    };

    if (start == null) return records;
    return records
        .where((r) => !r.date.isBefore(start) && !r.date.isAfter(today))
        .toList();
  }

  WeightRecord? get currentRecord {
    final today = _today;
    WeightRecord? current;
    for (final record in records) {
      if (record.date.isAfter(today)) break;
      current = record;
    }
    return current;
  }

  double? get lastWeight => currentRecord?.weightKg;

  double? get recentChange {
    final today = _today;
    final past = records.where((r) => !r.date.isAfter(today)).toList();
    if (past.length < 2) return null;
    return past.last.weightKg - past[past.length - 2].weightKg;
  }

  double? get minWeight {
    if (records.isEmpty) return null;
    return records.map((r) => r.weightKg).reduce(min);
  }

  double? get maxWeight {
    if (records.isEmpty) return null;
    return records.map((r) => r.weightKg).reduce(max);
  }

  double? get weeklyLossRate {
    final inRange = recordsInRange;
    if (inRange.length < 2) return null;
    final first = inRange.first;
    final last = inRange.last;
    final days = last.date.difference(first.date).inDays;
    if (days <= 0) return null;
    return (first.weightKg - last.weightKg) / (days / 7);
  }

  bool get isHealthyLoss {
    final rate = weeklyLossRate;
    if (rate == null) return true;
    return rate <= 1.0;
  }

  double? get goalProgress {
    final target = targetWeight;
    if (target == null) return null;
    final inRange = recordsInRange;
    if (inRange.length < 2) return null;
    final start = inRange.first.weightKg;
    final current = inRange.last.weightKg;
    if (start <= target) return 0.0;
    return ((start - current) / (start - target)).clamp(0.0, 1.0);
  }

  WeightState copyWith({
    bool? loading,
    bool? adding,
    List<WeightRecord>? records,
    WeightRange? range,
  }) {
    return WeightState(
      loading: loading ?? this.loading,
      adding: adding ?? this.adding,
      records: records ?? this.records,
      range: range ?? this.range,
      targetWeight: targetWeight,
    );
  }
}