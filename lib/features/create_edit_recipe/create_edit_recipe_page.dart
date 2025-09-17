import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/models/recipe.dart';
import '../recipe/bloc/recipe_bloc.dart';
import 'view/recipe_form.dart';

class CreateEditRecipePage extends StatelessWidget {
  final Recipe? recipe;
  const CreateEditRecipePage({
    super.key,
    this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('recipe_form.new_recipe'.tr()),
          backgroundColor: Colors.transparent,
        ),
        body: RecipeForm(updateRecipe: recipe),
      ),
    );
  }
}
