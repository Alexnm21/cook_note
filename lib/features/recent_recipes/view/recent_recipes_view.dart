import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/recipe_card.dart';
import '../bloc/recent_recipes_list_bloc.dart';

class RecentRecipesView extends StatelessWidget {
  const RecentRecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentRecipesListBloc, RecentRecipesListState>(
      builder: (context, state) {
        final recentRecipes = state.recipes;
        if (recentRecipes.isEmpty) {
          return const Center(
            child: Text('No hay recetas recientes'),
          );
        }
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: recentRecipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(
              recipe: recentRecipes[index],
            );
          },
        );
      },
    );
  }
}
