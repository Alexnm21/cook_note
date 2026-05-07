// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

class LoginState {
  final PostgrestException? error;
  final bool loginView;
  final bool loading;

  LoginState({this.error, this.loginView = true, this.loading = false});

  LoginState copyWith({
    PostgrestException? Function()? error,
    bool? loginView,
    bool? loading,
  }) {
    return LoginState(
      error: error != null ? error() : this.error,
      loginView: loginView ?? this.loginView,
      loading: loading ?? this.loading,
    );
  }
}
