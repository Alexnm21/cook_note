import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/styles/base_spaces.dart';
import '../../../core/blocs/user_bloc.dart';
import '../../../widgets/recipe_card.dart';
import '../bloc/recipe_list_bloc.dart';

part '../parts/my_recipes_list_part.dart';

class MyRecipesView extends StatelessWidget {
  const MyRecipesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipeListBloc(
        userId: context.read<UserBloc>().getUserId(),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: Text('home.myRecipes.title'.tr()),
          ),
          body: Padding(
            padding: paddings.x.s24,
            child: const Column(
              children: [
                Text('Search'),
                Text('Filter'),
                MyRecipesListPart(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.pushNamed('createRecipe');
            },
            child: const Icon(
              Icons.add,
            ),
          )),
    );
  }
}
