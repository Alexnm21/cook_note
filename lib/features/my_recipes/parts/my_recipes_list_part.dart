part of '../view/my_recipes_view.dart';

class MyRecipesListPart extends StatelessWidget {
  const MyRecipesListPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
        builder: (context, state) {
      if (state.isLoading) {
        return const Expanded(
            child: Center(child: CircularProgressIndicator()));
      }
      final filteredRecipes = state.filteredRecipes;

      if (state.recipes.isEmpty) {
        return Text('recipes.no_recipes'.tr());
      }

      if (filteredRecipes.isEmpty && state.searchText.isNotEmpty) {
        return Text(
            '${'recipes.no_recipes_matching'.tr()} "${state.searchText}"');
      }

      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          padding: paddings.x.s16,
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(recipe: filteredRecipes[index]);
          },
        ),
      );
    });
  }
}
