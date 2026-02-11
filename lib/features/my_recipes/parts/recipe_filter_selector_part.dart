part of '../view/my_recipes_view.dart';

class RecipeFilterSelectorPart extends StatelessWidget {
  final Set<Occasion> filterOccasions;
  final Function(Occasion) onFilterOccasion;
  const RecipeFilterSelectorPart({
    super.key,
    required this.filterOccasions,
    required this.onFilterOccasion,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizes.s40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: paddings.x.s16,
        children: Occasion.values
            .map((e) => _FilterContainer(
                occasion: e,
                selected: filterOccasions.contains(e),
                onFilterOccasion: onFilterOccasion))
            .toList(),
      ),
    );
  }
}

class _FilterContainer extends StatelessWidget {
  final Occasion occasion;
  final bool selected;
  final Function(Occasion) onFilterOccasion;
  final double borderRadius = 40;
  const _FilterContainer({
    required this.occasion,
    required this.selected,
    required this.onFilterOccasion,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onFilterOccasion(occasion),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: paddings.x.s4,
        padding:
            EdgeInsets.symmetric(horizontal: sizes.s12, vertical: sizes.s6),
        alignment: Alignment.center,
        decoration: selected ? _selectedDecoration() : _unselectedDecoration(),
        child: Text(
          'recipe.occasion.${occasion.name}'.tr(),
          style: baseTextStyle.h3
              .copyWith(color: selected ? Colors.white : Colors.grey),
        ),
      ),
    );
  }

  BoxDecoration _selectedDecoration() => BoxDecoration(
        color: AppColors.primary,
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(borderRadius),
      );

  BoxDecoration _unselectedDecoration() => BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(borderRadius),
      );
}
