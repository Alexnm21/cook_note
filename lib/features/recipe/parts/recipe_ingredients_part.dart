part of '../view/recipe_view.dart';

class RecipeIngredientsPart extends StatelessWidget {
  final Recipe recipe;
  const RecipeIngredientsPart({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings.all.s16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('recipe.ingredients'.tr(), style: baseTextStyle.h2),
          spacings.y.s16,
          ...recipe.ingredients.map((ingredient) => Padding(
                padding: paddings.bottom.s8,
                child: Row(
                  children: [
                    Container(
                      width: sizes.s8,
                      height: sizes.s8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    spacings.x.s12,
                    Expanded(
                      child: Text(
                        ingredient.name,
                        style: baseTextStyle.h3
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${ingredient.grams} ${ingredient.unit?.toString().split('.').last ?? ''}',
                      style: baseTextStyle.h3.copyWith(color: Colors.blueGrey),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
