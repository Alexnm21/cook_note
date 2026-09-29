import 'package:cook_note/core/models/weight_record.dart';
import 'package:cook_note/features/weight/bloc/weight_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  WeightRecord record(int daysAgo, double kg) {
    return WeightRecord(
      weightKg: kg,
      date: today().subtract(Duration(days: daysAgo)),
    );
  }

  WeightState stateWith(List<WeightRecord> records, {WeightRange? range}) {
    return WeightState(
      loading: false,
      records: records,
      range: range ?? WeightRange.all,
    );
  }

  group('WeightState.recordsInRange', () {
    test('con WeightRange.all devuelve todos los registros', () {
      final state = stateWith([
        record(400, 80),
        record(100, 78),
        record(5, 76),
      ]);

      expect(state.recordsInRange.length, 3);
    });

    test('excluye los registros anteriores al inicio del rango', () {
      final state = stateWith(
        [
          record(400, 80),
          record(20, 77),
        ],
        range: WeightRange.oneMonth,
      );

      expect(state.recordsInRange.length, 1);
      expect(state.recordsInRange.single.weightKg, 77);
    });

    test('excluye los registros con fecha futura', () {
      final state = stateWith(
        [
          record(1, 76),
          record(-5, 75),
        ],
        range: WeightRange.oneMonth,
      );

      expect(state.recordsInRange.length, 1);
      expect(state.recordsInRange.single.weightKg, 76);
    });
  });

  group('WeightState peso actual', () {
    test('currentRecord devuelve null sin registros', () {
      expect(stateWith([]).currentRecord, isNull);
      expect(stateWith([]).lastWeight, isNull);
    });

    test('lastWeight y recentChange con dos registros', () {
      final state = stateWith([
        record(10, 80),
        record(2, 78.5),
      ]);

      expect(state.lastWeight, 78.5);
      expect(state.recentChange, closeTo(-1.5, 0.001));
    });

    test('recentChange es null con un solo registro', () {
      expect(stateWith([record(1, 80)]).recentChange, isNull);
    });
  });

  group('WeightState estadísticas', () {
    test('minWeight y maxWeight con varios registros', () {
      final state = stateWith([
        record(30, 82),
        record(20, 78),
        record(10, 80.5),
      ]);

      expect(state.minWeight, 78);
      expect(state.maxWeight, 82);
    });

    test('weeklyLossRate calcula la bajada por semana', () {
      final state = stateWith([
        record(28, 80),
        record(0, 76),
      ]);

      expect(state.weeklyLossRate, closeTo(1.0, 0.001));
      expect(state.isHealthyLoss, isTrue);
    });

    test('isHealthyLoss es false con una bajada superior a 1 kg/semana', () {
      final state = stateWith([
        record(28, 90),
        record(0, 80),
      ]);

      expect(state.isHealthyLoss, isFalse);
    });

    test('weeklyLossRate es null si el rango tiene menos de dos registros', () {
      expect(stateWith([record(1, 80)]).weeklyLossRate, isNull);
    });
  });

  group('WeightState.goalProgress', () {
    test('es null sin peso objetivo', () {
      final state = stateWith([
        record(28, 80),
        record(0, 78),
      ]);

      expect(state.goalProgress, isNull);
    });

    test('progresa hacia el objetivo', () {
      final state = WeightState(
        loading: false,
        records: [
          record(28, 80),
          record(0, 76),
        ],
        range: WeightRange.all,
        targetWeight: 70,
      );

      expect(state.goalProgress, closeTo(0.4, 0.001));
    });

    test('se limita a 1.0 al superar el objetivo', () {
      final state = WeightState(
        loading: false,
        records: [
          record(28, 80),
          record(0, 65),
        ],
        range: WeightRange.all,
        targetWeight: 70,
      );

      expect(state.goalProgress, 1.0);
    });
  });

  group('WeightRecord', () {
    test('toMap usa weight_kg y dateKey', () {
      final map = WeightRecord(
        weightKg: 78.4,
        date: DateTime(2026, 3, 7),
      ).toMap();

      expect(map['weight_kg'], 78.4);
      expect(map['date'], '2026-03-07');
    });

    test('fromMap lee el id, el peso y la fecha', () {
      final record = WeightRecord.fromMap({
        'id': 'abc-123',
        'weight_kg': 71.2,
        'date': '2026-01-15',
      });

      expect(record.id, 'abc-123');
      expect(record.weightKg, 71.2);
      expect(record.date, DateTime(2026, 1, 15));
      expect(record.dateKey, '2026-01-15');
    });
  });
}
