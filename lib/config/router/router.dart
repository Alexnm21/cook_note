import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

late final GoRouter router;

/// Repaints GoRouter whenever the auth state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notificationStream =
        stream.asBroadcastStream().listen((dynamic _) => notifyListeners());
  }

  late final StreamSubscription<dynamic> notificationStream;

  @override
  void dispose() {
    notificationStream.cancel();
    super.dispose();
  }
}

GoRouter buildRouter(UserBloc userBloc) {
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(userBloc.stream),
    redirect: (context, state) {
      final isLoggedIn = userBloc.state is UserLoggedIn;
      final location = state.matchedLocation;
      final isProtected = location != '/' && location != '/forgotPassword';

      if (!isLoggedIn && isProtected) {
        return '/';
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider.value(
            value: userBloc,
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoggedIn) {
                  return BlocProvider(
                    key: ValueKey(userState.user.id),
                    create: (context) =>
                        ProfileBloc(userId: userState.user.id),
                    child: child,
                  );
                }
                return child;
              },
            ),
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
}