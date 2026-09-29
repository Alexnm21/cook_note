import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/weight_record.dart';
import '../../../data/abstract/weight_repository.dart';
import '../../../data/supabase/supabase_weight_repository.dart';

part 'weight_event.dart';
part 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final WeightRepository weightRepository;
  final String userId;

  WeightBloc({
    WeightRepository? weightRepository,
    required this.userId,
    int? targetWeight,
  })  : weightRepository =
            weightRepository ?? SupabaseWeightRepository.instance(),
        super(WeightState(targetWeight: targetWeight)) {
    on<SetWeightRecords>((event, emit) {
      emit(state.copyWith(records: event.records));
    });

    on<SetLoading>((event, emit) {
      emit(state.copyWith(loading: event.loading));
    });

    on<SetAdding>((event, emit) {
      emit(state.copyWith(adding: event.adding));
    });

    on<SetRange>((event, emit) {
      emit(state.copyWith(range: event.range));
    });

    init();
  }

  Future<void> init() async {
    await loadRecords();
  }

  Future<void> loadRecords() async {
    final records = await weightRepository.getWeightRecords(userId);
    add(SetWeightRecords(records: records));
    add(SetLoading(loading: false));
  }

  void setRange(WeightRange range) {
    add(SetRange(range: range));
  }

  Future<void> addWeightRecord(WeightRecord record) async {
    add(SetAdding(adding: true));
    try {
      await weightRepository.addWeightRecord(record, userId);
      await loadRecords();
    } finally {
      add(SetAdding(adding: false));
    }
  }
}