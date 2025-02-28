import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/blocs/user_bloc.dart';
import 'features/home/home_page.dart';
import 'features/login/login_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoggedIn) {
            return const HomePage();
          } else if (state is UserLoggedOut) {
            return const LoginPage();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
