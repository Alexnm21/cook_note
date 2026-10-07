import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_radius.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/enums/enums.dart';
import '../../../core/models/recipe.dart';
import '../../../core/utils/dialog_utils.dart';
import '../../../widgets/svg_icon.dart';
import '../bloc/recipe_bloc.dart';

part '../parts/header_part.dart';
part '../parts/recipe_details_part.dart';
part '../parts/recipe_ingredients_part.dart';
part '../parts/recipe_macros_part.dart';
part '../parts/recipe_steps_part.dart';
part '../parts/recipe_title_part.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;
  const RecipeView({super.key, required this.recipe});

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late Recipe recipe;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
  }

  void addPortion() {
    setState(() {
      recipe = recipe.addPortion();
    });
  }

  void removePortion() {
    setState(() {
      recipe = recipe.removePortion();
    });
  }

  void confirmDelete() {
    showAlertDialog(
      context,
      title: 'recipe.delete_title'.tr(),
      body: 'recipe.delete_confirm'.tr(args: [recipe.name]),
      onAccept: _deleteRecipe,
      onReject: () {},
    );
  }

  Future<void> _deleteRecipe() async {
    final recipeBloc = context.read<RecipeBloc>();

    setState(() {
      _deleting = true;
    });

    try {
      await recipeBloc.deleteRecipe(recipe.id);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _deleting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('recipe.delete_error'.tr())),
      );
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('recipe.deleted'.tr())),
    );
    router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        HeaderPart(recipe: recipe, deleting: _deleting, onDelete: confirmDelete),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecipeTitlePart(recipe: recipe),
              RecipeDetailsPart(
                recipe: recipe,
                onAddPortion: addPortion,
                onRemovePortion: removePortion,
              ),
              RecipeMacrosPart(recipe: recipe),
              RecipeIngredientsPart(recipe: recipe),
              RecipeStepsPart(recipe: recipe),
            ],
          ),
        ),
      ],
    );
  }
}
