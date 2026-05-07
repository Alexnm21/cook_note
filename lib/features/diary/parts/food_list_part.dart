part of '../view/diary_view.dart';

class FoodListPart extends StatelessWidget {
  const FoodListPart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: Occasion.values.length,
          itemBuilder: (context, index) {
            final occasion = Occasion.values[index];
            final recipes = state.diaryDay.meals
                .where((meal) => meal.occasion == occasion)
                .map((meal) => meal.recipe)
                .toList();
            return OcassionTilePart(
              occasion: occasion,
              recipes: recipes,
            );
          },
        );
      },
    );
  }
}
