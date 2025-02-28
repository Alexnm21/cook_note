part of '../view/my_recipes_view.dart';

class MyRecipesListPart extends StatelessWidget {
  const MyRecipesListPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('home.myRecipes.title'.tr()),
      ],
    );
  }
}
