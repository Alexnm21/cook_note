part of '../view/recipe_view.dart';

class RecipeTitlePart extends StatelessWidget {
  final Recipe recipe;
  const RecipeTitlePart({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings.all.s16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: recipe.occasions
                .map((occasion) => Container(
                      margin: paddings.right.s8,
                      padding: EdgeInsets.symmetric(
                        horizontal: sizes.s8,
                        vertical: sizes.s4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(BaseRadius.m),
                      ),
                      child: Text(
                        'recipe.occasion.${occasion.name}'.tr(),
                        style: baseTextStyle.h2.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ))
                .toList(),
          ),
          spacings.y.s12,
          Text(
            recipe.name,
            style: baseTextStyle.h1,
          ),
          spacings.y.s12,
          Text(
            recipe.description ?? '',
            style: baseTextStyle.h4.copyWith(color: Colors.blueGrey),
          ),
        ],
      ),
    );
  }
}
