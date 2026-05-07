import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/theme/app_colors.dart';
import '../core/blocs/user_bloc.dart';
import '../core/models/recipe.dart';
import '../features/create_edit_recipe/view/recipe_form.dart';
import '../features/recipe/bloc/recipe_bloc.dart';

class CreateEditRecipePage extends StatelessWidget {
  final Recipe? recipe;
  const CreateEditRecipePage({
    super.key,
    this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeBloc(
        userBloc: context.read<UserBloc>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.formBackground,
        appBar: AppBar(
          title: Text('recipe_form.new_recipe'.tr()),
          backgroundColor: Colors.transparent,
        ),
        body: RecipeForm(updateRecipe: recipe),
      ),
    );
  }
}
