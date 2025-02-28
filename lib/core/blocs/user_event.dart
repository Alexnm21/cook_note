part of 'user_bloc.dart';

abstract class UserEvent {}

class LoggedIn extends UserEvent {
  final User user;
  LoggedIn({required this.user});
}

class LoggedOut extends UserEvent {}
