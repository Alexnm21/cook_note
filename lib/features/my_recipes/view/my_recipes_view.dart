import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part '../parts/my_recipes_list_part.dart';

class MyRecipesView extends StatelessWidget {
  const MyRecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('home.myRecipes.title'.tr()),
        ),
        body: const MyRecipesListPart(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.goNamed('createRecipe');
          },
          child: const Icon(
            Icons.add,
          ),
        ));
  }
}
