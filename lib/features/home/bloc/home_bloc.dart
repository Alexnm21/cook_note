import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../my_recipes/view/my_recipes_view.dart';
import '../../profile/view/profile_view.dart';

part 'home_event.dart';
part 'home_state.dart';

enum HomePages {
  myRecipes("home.myRecipes.title", "recipe", MyRecipesView()),
  profile("home.profile", "profile", ProfileView());

  final String label;
  final String icon;
  final Widget view;

  const HomePages(this.label, this.icon, this.view);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<ChangePage>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
    });
  }

  changePage(HomePages page) {
    add(ChangePage(page: page));
  }
}
