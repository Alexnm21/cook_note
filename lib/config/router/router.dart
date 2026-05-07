import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/blocs/user_bloc.dart';
import '../../core/models/profile.dart';
import '../../core/models/recipe.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../main_app.dart';
import '../../pages/create_edit_recipe_page.dart';
import '../../pages/edit_profile_page.dart';
import '../../pages/forgot_password_page.dart';
import '../../pages/recent_recipes_page.dart';
import '../../pages/recipe_page.dart';

enum Routes {
  home,
  createRecipe,
  editRecipe,
  forgotPassword,
  recipe,
  editProfile,
  recentRecipes,
}

final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => UserBloc()),
            BlocProvider(
                create: (context) => ProfileBloc(
                      userId: context.read<UserBloc>().getUserId(),
                    )),
          ],
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          name: Routes.home.name,
          builder: (context, state) => const MainApp(),
        ),
        GoRoute(
          path: '/createRecipe',
          name: Routes.createRecipe.name,
          builder: (context, state) => const CreateEditRecipePage(),
        ),
        GoRoute(
          path: '/editRecipe',
          name: Routes.editRecipe.name,
          builder: (context, state) => CreateEditRecipePage(
            recipe: state.extra as Recipe?,
          ),
        ),
        GoRoute(
          path: '/recipe',
          name: Routes.recipe.name,
          builder: (context, state) => RecipePage(
            recipe: state.extra as Recipe,
          ),
        ),
        GoRoute(
          path: '/editProfile',
          name: Routes.editProfile.name,
          builder: (context, state) => EditProfilePage(
            profile: state.extra as Profile,
          ),
        ),
        GoRoute(
          path: '/recentRecipes',
          name: Routes.recentRecipes.name,
          builder: (context, state) => const RecentRecipesPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/forgotPassword',
      name: Routes.forgotPassword.name,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
  ],
);
