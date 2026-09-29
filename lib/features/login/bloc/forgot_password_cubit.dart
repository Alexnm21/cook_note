import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/abstract/login_repository.dart';
import '../../../data/supabase/supabase_login_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({LoginRepository? loginRepository})
      : _loginRepository =
            loginRepository ?? SupabaseLoginRepository.instance(),
        super(const ForgotPasswordState());

  final LoginRepository _loginRepository;

  Future<void> sendResetEmail(String email) async {
    if (state.loading) return;
    emit(const ForgotPasswordState(loading: true));
    try {
      await _loginRepository.resetPasswordForEmail(email.trim());
      if (!isClosed) emit(const ForgotPasswordState(success: true));
    } catch (e) {
      if (!isClosed) {
        emit(ForgotPasswordState(error: _mapError(e)));
      }
    }
  }

  String _mapError(Object e) {
    if (e is AuthException) {
      return '${'login.errors.auth_error'.tr()}: ${e.message}';
    }
    return 'login.errors.unexpected_error'.tr();
  }
}