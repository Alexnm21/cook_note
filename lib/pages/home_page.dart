import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/theme/app_colors.dart';
import '../core/blocs/user_bloc.dart';
import '../features/home/bloc/home_bloc.dart';
import '../features/my_recipes/bloc/recipe_list_bloc.dart';
import '../widgets/svg_icon.dart';

part '../features/home/parts/home_navigation_bar_part.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeBloc()),
        BlocProvider(
          create: (context) => RecipeListBloc(
            userId: context.read<UserBloc>().getUserId(),
          ),
          lazy: false,
        ),
      ],
      child: Scaffold(
          bottomNavigationBar: const HomeNavigationBarPart(),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return SafeArea(child: state.currentPage.view);
            },
          )),
    );
  }
}
