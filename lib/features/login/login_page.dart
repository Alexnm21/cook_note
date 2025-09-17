import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/dialog_utils.dart';
import 'bloc/login_bloc.dart';
import 'view/login_view.dart';
import 'view/register_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        body: BlocConsumer<LoginBloc, LoginState>(
          listenWhen: (previous, current) => previous.error != current.error,
          listener: (context, state) {
            if (state.error != null) {
              showAlertDialog(
                context,
                title: state.error?.details.toString() ?? 'Error',
                body: state.error?.message ?? '',
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child:
                    state.loginView ? const LoginView() : const RegisterView(),
              ),
            );
          },
        ),
      ),
    );
  }
}
