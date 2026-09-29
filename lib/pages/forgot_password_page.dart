import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/theme/styles/base_spaces.dart';
import '../config/theme/styles/base_text_style.dart';
import '../core/utils/dialog_utils.dart';
import '../core/utils/validation_service.dart';
import '../features/login/bloc/forgot_password_cubit.dart';
import '../features/login/bloc/forgot_password_state.dart';
import '../widgets/custom_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final TextEditingController emailCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  void _sendResetEmail() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordCubit>().sendResetEmail(emailCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
              listenWhen: (previous, current) =>
                  previous.error != current.error ||
                  previous.success != current.success,
              listener: (context, state) {
                if (state.error != null) {
                  showAlertDialog(
                    context,
                    title: 'login.errors.auth_error'.tr(),
                    body: state.error!,
                  );
                } else if (state.success) {
                  showAlertDialog(
                    context,
                    title: 'login.forgot_password.sentTitle'.tr(),
                    body: 'login.forgot_password.sentBody'.tr(),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    spacings.y.s16,
                    Text(
                      'login.forgot_password.title'.tr(),
                      style: baseTextStyle.h1,
                    ),
                    spacings.y.s10,
                    Text(
                      'login.forgot_password.description'.tr(),
                      style: baseTextStyle.body,
                    ),
                    spacings.y.s24,
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'login.email'.tr(),
                        prefixIcon: const Icon(Icons.email),
                        border: const OutlineInputBorder(),
                      ),
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) =>
                          ValidationService.validateEmail(value)?.tr(),
                    ),
                    spacings.y.s24,
                    CustomButton(
                      onPressed: state.loading ? () {} : _sendResetEmail,
                      child: state.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('login.forgot_password.send'.tr()),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}