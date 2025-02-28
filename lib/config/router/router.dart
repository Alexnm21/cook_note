import 'package:go_router/go_router.dart';

import '../../features/create_recipe/create_recipe_page.dart';
import '../../main_app.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) => const MainApp(),
  ),
  GoRoute(
    path: '/createRecipe',
    name: 'createRecipe',
    builder: (context, state) => const CreateRecipePage(),
  ),
]);
