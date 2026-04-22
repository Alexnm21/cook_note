import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/router/router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/styles/base_spaces.dart';
import '../../../config/theme/styles/base_text_style.dart';
import '../../../core/enums/occasion.dart';
import '../../../core/extensions/build_context_extension.dart';
import '../../../core/models/recipe.dart';
import '../../../widgets/recipe_card.dart';
import '../../../widgets/recipe_list_tile.dart';
import '../../../widgets/svg_icon.dart';
import '../bloc/recipe_list_bloc.dart';

part '../parts/my_recipes_list_part.dart';
part '../parts/recent_recipes_part.dart';
part '../parts/recipe_filter_selector_part.dart';

class MyRecipesView extends StatelessWidget {
  const MyRecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            BlocBuilder<RecipeListBloc, RecipeListState>(
              builder: (context, state) {
                return Padding(
                  padding: paddings.x.s16,
                  child: SearchBar(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    hintText: 'core.search'.tr(),
                    onChanged: (value) {
                      context.read<RecipeListBloc>().searchRecipes(value);
                    },
                    leading: const SvgIcon(icon: 'search'),
                    padding: WidgetStateProperty.all(paddings.x.s16),
                  ),
                );
              },
            ),
            spacings.y.s24,
            BlocBuilder<RecipeListBloc, RecipeListState>(
              builder: (context, state) {
                return RecipeFilterSelectorPart(
                  filterOccasion: state.filterOccasion,
                  onFilterOccasion: (occasion) {
                    context.read<RecipeListBloc>().filterOccasion(occasion);
                  },
                );
              },
            ),
            spacings.y.s24,
            const RecentRecipesPart(),
            const MyRecipesListPart(),
            spacings.y.s12,
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed('createRecipe');
          },
          child: const Icon(
            Icons.add,
          ),
        ));
  }
}
