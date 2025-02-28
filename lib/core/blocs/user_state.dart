part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoggedIn extends UserState {
  final User user;
  UserLoggedIn({required this.user});
}

class UserLoggedOut extends UserState {}
