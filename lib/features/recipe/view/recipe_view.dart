import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/router/router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_radius.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/enums/enums.dart';
import '../../../core/models/recipe.dart';
import '../../../widgets/svg_icon.dart';

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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        HeaderPart(recipe: recipe),
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
