import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/recent_recipes/bloc/recent_recipes_list_bloc.dart';
import '../features/recent_recipes/view/recent_recipes_view.dart';

class RecentRecipesPage extends StatelessWidget {
  const RecentRecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas recientes'),
      ),
      body: BlocProvider(
        create: (context) => RecentRecipesListBloc(),
        child: const RecentRecipesView(),
      ),
    );
  }
}
