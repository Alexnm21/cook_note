import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/blocs/user_bloc.dart';
import '../core/models/recipe.dart';
import '../features/recipe/bloc/recipe_bloc.dart';
import '../features/recipe/view/recipe_view.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  const RecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(
        userBloc: context.read<UserBloc>(),
      ),
      child: Scaffold(
        body: RecipeView(recipe: recipe),
      ),
    );
  }
}
