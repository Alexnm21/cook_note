import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config/router/router.dart';
import '../../config/theme/styles/base_radius.dart';
import '../../config/theme/styles/base_spaces.dart';
import '../../config/theme/styles/base_text_style.dart';
import '../../core/enums/occasion.dart';
import '../../core/models/recipe.dart';
import '../../features/my_recipes/bloc/recipe_list_bloc.dart';
import '../custom_button.dart';
import '../svg_icon.dart';
import 'new_recipe_dialog.dart';

// This widget is a popup dialog for selecting a recipe.
// It displays a list of available recipes for a given occasion and allows the user to choose one.
// It uses the RecipeListBloc to get the list of recipes and the RecipeRepository to get the recipes from the database.
class SingleSelectionRecipeDialog extends StatelessWidget {
  final Occasion occasion;
  final Function(Recipe) onSelected;
  const SingleSelectionRecipeDialog({
    super.key,
    required this.occasion,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: paddings.all.s6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(BaseRadius.s),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<RecipeListBloc, RecipeListState>(
              builder: (context, state) {
                final List<Recipe> recipeList = state.recipes
                    .where((r) => r.occasions.contains(occasion))
                    .toList();
                return Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => _RecipeItem(
                      recipe: recipeList[index],
                      onSelected: () {
                        onSelected(recipeList[index]);
                        router.pop();
                      },
                    ),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemCount: recipeList.length,
                  ),
                );
              },
            ),
            spacings.y.s6,
            CustomButton(
              child: Text(
                'recipe_form.new_recipe'.tr(),
                style: baseTextStyle.h2.copyWith(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                router.pop();
                _showNewRecipeDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  _showNewRecipeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewRecipeDialog(
        onSave: onSelected,
      ),
    );
    // Navigator.ofcontext) => NewRecipeDialog());
  }
}

class _RecipeItem extends StatelessWidget {
  final Recipe recipe;
  final Function() onSelected;
  const _RecipeItem({required this.recipe, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: recipe.image != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(BaseRadius.s),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  fit: BoxFit.cover,
                  recipe.image ?? '',
                ),
              ))
          : const SvgIcon(icon: "food"),
      title: Text(
        recipe.name,
        style: baseTextStyle.h3.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      splashColor: Colors.grey.withValues(alpha: 0.2),
      subtitle: Text('${recipe.calories.round()} kcal'),
      onTap: onSelected,
    );
  }
}
