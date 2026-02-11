import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/router.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/utils/validation_service.dart';
import '../../../widgets/svg_icon.dart';
import '../bloc/login_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  login() async {
    if (_formKey.currentState!.validate()) {
      await context.read<LoginBloc>().loginWithEmailAndPassword(
            emailCtrl.text,
            passwordCtrl.text,
          );
    }
  }

  goRegisterView() {
    context.read<LoginBloc>().setLoginView(false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              spacings.y.s10,
              const SvgIcon(icon: 'cooking', size: 200),
              spacings.y.s32,
              Text(
                'login.title'.tr(),
                style: baseTextStyle.h1,
              ),
              spacings.y.s16,
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
              spacings.y.s16,
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'login.password'.tr(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: SvgIcon(
                      icon: !obscurePassword ? 'eye_open' : 'eye_closed',
                    ),
                  ),
                  border: const OutlineInputBorder(),
                ),
                controller: passwordCtrl,
                obscureText: obscurePassword,
                validator: (value) =>
                    ValidationService.validatePassword(value)?.tr(),
              ),
              spacings.y.s8,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      router.pushNamed(Routes.forgotPassword.name);
                    },
                    child: Text(
                      'login.forgotPassword'.tr(),
                      style: baseTextStyle.h3.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              spacings.y.s30,
              ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  'login.title'.tr(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              spacings.y.s30,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'login.alreadyHaveAccount'.tr(),
                    style: baseTextStyle.h3,
                  ),
                  spacings.x.s5,
                  GestureDetector(
                    onTap: goRegisterView,
                    child: Text(
                      'login.register'.tr(),
                      style: baseTextStyle.h3.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
