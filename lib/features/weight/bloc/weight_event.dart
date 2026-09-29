part of 'weight_bloc.dart';

abstract class WeightEvent {}

class SetWeightRecords extends WeightEvent {
  final List<WeightRecord> records;
  SetWeightRecords({required this.records});
}

class SetLoading extends WeightEvent {
  final bool loading;
  SetLoading({required this.loading});
}

class SetAdding extends WeightEvent {
  final bool adding;
  SetAdding({required this.adding});
}

class SetRange extends WeightEvent {
  final WeightRange range;
  SetRange({required this.range});
}