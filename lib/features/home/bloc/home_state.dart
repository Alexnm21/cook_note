part of 'home_bloc.dart';

class HomeState {
  final HomePages currentPage;

  HomeState({
    this.currentPage = HomePages.diary,
  });

  HomeState copyWith({HomePages? currentPage}) {
    return HomeState(currentPage: currentPage ?? this.currentPage);
  }

  get currentPageIndex => currentPage.index;
}
