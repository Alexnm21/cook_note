part of '../view/my_recipes_view.dart';

class MyRecipesListPart extends StatelessWidget {
  const MyRecipesListPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
        builder: (context, state) {
      if (state.recipes.isEmpty) {
        return const Text('No recipes found');
      }
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: state.recipes.length,
          itemBuilder: (context, index) {
            return RecipeCard(recipe: state.recipes[index]);
          },
        ),
      );
    });
  }
}
