part of 'home_bloc.dart';

abstract class HomeEvent {}

class ChangePage extends HomeEvent {
  final HomePages page;

  ChangePage({required this.page});
}
