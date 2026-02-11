part of '../view/recipe_view.dart';

class RecipeMacrosPart extends StatelessWidget {
  final Recipe recipe;
  const RecipeMacrosPart({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalMargin = screenWidth / 5;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 10),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
        children: [
          _MacroItem(
            label: 'macros.calories'.tr(),
            value: '${recipe.calories.round()}',
            icon: 'calories',
          ),
          _MacroItem(
            label: 'macros.protein'.tr(),
            value: '${recipe.protein.round()} g',
            icon: 'protein',
          ),
          _MacroItem(
            label: 'macros.carbs'.tr(),
            value: '${recipe.carbs.round()} g',
            icon: 'carbs',
          ),
          _MacroItem(
            label: 'macros.fat'.tr(),
            value: '${recipe.fat.round().toString()} g',
            icon: 'fat',
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _MacroItem(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddings.all.s8,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(BaseRadius.l),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(icon: icon, size: 34, color: Colors.white),
          spacings.y.s4,
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          Text(
            label,
            style: baseTextStyle.h3.copyWith(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
