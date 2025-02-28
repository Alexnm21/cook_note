import 'package:flutter/material.dart';

import 'view/recipe_form.dart';

class CreateRecipePage extends StatelessWidget {
  const CreateRecipePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RecipeForm(),
    );
  }
}
