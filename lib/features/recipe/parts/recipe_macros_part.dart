part of '../view/recipe_view.dart';

class RecipeMacrosPart extends StatelessWidget {
  final Recipe recipe;
  const RecipeMacrosPart({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddings.all.s16,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _MacroItem(
            macros: Macros.calories,
            value: '${recipe.calories.round()}',
          ),
          _MacroItem(
            macros: Macros.protein,
            value: '${recipe.protein.round()} g',
          ),
          _MacroItem(
            macros: Macros.carbs,
            value: '${recipe.carbs.round()} g',
          ),
          _MacroItem(
            macros: Macros.fat,
            value: '${recipe.fat.round().toString()} g',
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final Macros macros;
  final String value;

  const _MacroItem({required this.macros, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddings.all.s8,
      decoration: BoxDecoration(
        color: macros.color.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(BaseRadius.m),
        border: Border.all(color: macros.color, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            macros.text.toUpperCase(),
            style: baseTextStyle.h3.copyWith(color: macros.color),
            overflow: TextOverflow.ellipsis,
          ),
          spacings.y.s4,
          Text(
            value,
            style: baseTextStyle.h2.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
