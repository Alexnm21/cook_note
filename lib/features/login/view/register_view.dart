import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/utils/validation_service.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/svg_icon.dart';
import '../bloc/login_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController nameCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  register() async {
    if (_formKey.currentState!.validate()) {
      await context.read<LoginBloc>().register(
            emailCtrl.text,
            passwordCtrl.text,
            nameCtrl.text,
          );
      showEmailConfirmationDialog();
    }
  }

  goLoginView() {
    context.read<LoginBloc>().setLoginView(true);
  }

  showEmailConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => CustomDialog(
        icon: const SvgIcon(icon: 'mail_sent', size: 100),
        title: 'login.register'.tr(),
        body: 'login.email_confirmation'.tr(),
        onAccept: () {
          context.read<LoginBloc>().closeLoadingDialog();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            spacings.y.s10,
            const SvgIcon(icon: 'barbecue', size: 200),
            spacings.y.s32,
            Text(
              'login.register'.tr(),
              style: baseTextStyle.h1,
            ),
            spacings.y.s16,
            TextFormField(
              decoration: InputDecoration(
                labelText: 'login.name'.tr(),
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
              controller: nameCtrl,
              validator: (value) => ValidationService.validateName(value)?.tr(),
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
            spacings.y.s30,
            SizedBox(
              width: double.infinity,
              height: sizes.s50,
              child: CustomButton(
                onPressed: () {
                  register();
                },
                child: BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    }
                    return Text('login.createAccount'.tr(),
                        style: baseTextStyle.h2.copyWith(
                          color: Colors.white,
                        ));
                  },
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'login.alreadyHaveAccount'.tr(),
                  style: baseTextStyle.h3,
                ),
                spacings.x.s5,
                GestureDetector(
                  onTap: goLoginView,
                  child: Text(
                    'login.title'.tr(),
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
    );
  }
}
