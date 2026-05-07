import 'package:flutter/material.dart';

import '../../config/theme/styles/base_spaces.dart';
import '../../core/models/recipe.dart';
import '../../features/create_edit_recipe/view/recipe_form.dart';

class NewRecipeDialog extends StatelessWidget {
  final Function(Recipe) onSave;
  const NewRecipeDialog({
    super.key,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: paddings.all.s6,
        child: RecipeForm(
          onSave: onSave,
        ),
      ),
    );
  }
}
