import 'package:flutter/material.dart';

import '../core/models/recipe.dart';
import '../features/recipe/view/recipe_view.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;
  const RecipePage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RecipeView(recipe: recipe),
    );
  }
}
