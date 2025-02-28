part of 'login_bloc.dart';

abstract class LoginEvent {}

class OnError extends LoginEvent {
  final String errorMessage;

  OnError(this.errorMessage);
}
