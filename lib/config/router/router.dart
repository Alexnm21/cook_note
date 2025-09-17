import 'package:go_router/go_router.dart';

import '../../core/models/recipe.dart';
import '../../features/create_edit_recipe/create_edit_recipe_page.dart';
import '../../features/login/forgot_password_page.dart';
import '../../main_app.dart';

enum Routes {
  home,
  createRecipe,
  editRecipe,
  forgotPassword,
}

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const MainApp(),
  ),
  GoRoute(
    path: '/forgotPassword',
    name: Routes.forgotPassword.name,
    builder: (context, state) => const ForgotPasswordPage(),
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
]);
