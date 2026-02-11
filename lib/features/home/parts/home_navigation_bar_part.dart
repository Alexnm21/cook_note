part of '../../../pages/home_page.dart';

class HomeNavigationBarPart extends StatelessWidget {
  const HomeNavigationBarPart({super.key});

  List<BottomNavigationBarItem> getItems() {
    return HomePages.values
        .map((e) => BottomNavigationBarItem(
              icon: SvgIcon(icon: e.icon, size: 24),
              activeIcon: SvgIcon(
                icon: e.icon,
                color: AppColors.primary,
                size: 28,
              ),
              label: e.label.tr(),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return BottomNavigationBar(
          items: getItems(),
          selectedItemColor: AppColors.primary,
          currentIndex: state.currentPageIndex,
          onTap: (index) {
            context.read<HomeBloc>().changePage(HomePages.values[index]);
          },
        );
      },
    );
  }
}
