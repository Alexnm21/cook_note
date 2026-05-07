part of 'login_bloc.dart';

abstract class LoginEvent {}

class OnError extends LoginEvent {
  final PostgrestException error;

  OnError(this.error);
}

class SetLoginView extends LoginEvent {
  final bool value;

  SetLoginView(this.value);
}

class SetLoading extends LoginEvent {
  final bool value;

  SetLoading(this.value);
}

class CloseLoadingDialog extends LoginEvent {
  CloseLoadingDialog();
}
