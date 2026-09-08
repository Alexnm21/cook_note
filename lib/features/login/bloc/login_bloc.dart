import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/abstract/login_repository.dart';
import '../../../data/supabase/supabase_login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;

  LoginBloc({LoginRepository? loginRepository})
      : loginRepository = loginRepository ?? SupabaseLoginRepository.instance(),
        super(LoginState()) {
    on<LoginEvent>((event, emit) {});
    on<OnError>((event, emit) {
      emit(state.copyWith(error: () => event.error));
    });
    on<SetLoginView>((event, emit) {
      emit(state.copyWith(loginView: event.value));
    });

    on<SetLoading>((event, emit) {
      emit(state.copyWith(loading: event.value));
    });

    on<CloseLoadingDialog>((event, emit) {
      emit(state.copyWith(loading: false, error: () => null));
    });
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await loginRepository.loginWithEmailAndPassword(
        email,
        password,
      );
    } catch (e) {
      _catchError(e);
      return null;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      add(SetLoading(true));
      await loginRepository.registerProfile(
        email: email,
        password: password,
        name: name,
      );
    } catch (e) {
      _catchError(e);
      add(SetLoading(false));
      return;
    }
  }

  setLoginView(bool value) {
    add(SetLoginView(value));
  }

  closeLoadingDialog() {
    add(CloseLoadingDialog());
  }

  _catchError(e) {
    if (e is PostgrestException) {
      add(OnError(e));
    } else if (e is AuthException) {
      String errorMessage = _getAuthErrorMessage(e);
      add(OnError(
          PostgrestException(details: 'Auth Error', message: errorMessage)));
    } else {
      // Manejar otros tipos de errores
      String errorMessage = _getGenericErrorMessage(e.toString());
      add(OnError(PostgrestException(details: 'Error', message: errorMessage)));
    }
  }

  String _getAuthErrorMessage(AuthException e) {
    switch (e.message) {
      case 'User already registered':
        return 'login.errors.email_already_registered'.tr();
      case 'Invalid email':
        return 'login.errors.invalid_email_format'.tr();
      case 'Password should be at least 6 characters':
        return 'login.errors.password_min_length'.tr();
      default:
        return '${'login.errors.auth_error'.tr()}: ${e.message}';
    }
  }

  String _getGenericErrorMessage(String error) {
    if (error.contains('email may already be registered') ||
        error.contains('already registered')) {
      return 'login.errors.email_already_registered'.tr();
    }
    return '${'login.errors.unexpected_error'.tr()}: $error';
  }
}
