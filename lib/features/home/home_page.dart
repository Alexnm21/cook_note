import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/theme/app_colors.dart';
import '../../widgets/svg_icon.dart';
import 'bloc/home_bloc.dart';

part 'parts/home_navigation_bar_part.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: Scaffold(
          bottomNavigationBar: const HomeNavigationBarPart(),
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return state.currentPage.view;
            },
          )),
    );
  }
}
