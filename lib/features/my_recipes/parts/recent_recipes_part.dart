part of '../view/my_recipes_view.dart';

class RecentRecipesPart extends StatelessWidget {
  const RecentRecipesPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        List<Recipe> recentRecipes = state.filteredRecentRecipes;
        if (recentRecipes.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: context.height * 0.3,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: paddings.left.s20,
                      child: Text(
                        'home.recentRecipes.title'.tr(),
                        style: baseTextStyle.h2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        router.pushNamed(Routes.recentRecipes.name);
                      },
                      child: Padding(
                        padding: paddings.right.s20,
                        child: Text(
                          'home.recentRecipes.viewAll'.tr(),
                          style: baseTextStyle.h2.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  color: context.theme.scaffoldBackgroundColor,
                  height: context.height * 0.25,
                  child: ListView.builder(
                    itemCount: recentRecipes.length,
                    padding: paddings.x.s16,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return RecipeCard(
                        recipe: recentRecipes[index],
                        width: context.width * 0.55,
                      );
                    },
                  ),
                ),
              ]),
        );
      },
    );
  }
}
