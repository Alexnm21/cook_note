part of '../view/my_recipes_view.dart';

class RecipeFilterSelectorPart extends StatelessWidget {
  final Occasion? filterOccasion;
  final Function(Occasion?) onFilterOccasion;
  const RecipeFilterSelectorPart({
    super.key,
    required this.filterOccasion,
    required this.onFilterOccasion,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: sizes.s40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: paddings.x.s16,
        children: [
          _FilterContainer(
              text: 'core.all'.tr(),
              selected: filterOccasion == null,
              onTap: () => onFilterOccasion(null)),
          ...Occasion.values.map((occasion) {
            return _FilterContainer(
                text: 'recipe.occasion.${occasion.name}'.tr(),
                selected: filterOccasion != null && filterOccasion == occasion,
                onTap: () => onFilterOccasion(occasion));
          })
        ],
      ),
    );
  }
}

class _FilterContainer extends StatelessWidget {
  final bool selected;
  final Function() onTap;
  final String text;
  final double borderRadius = 40;
  const _FilterContainer({
    required this.selected,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: paddings.x.s4,
        padding:
            EdgeInsets.symmetric(horizontal: sizes.s12, vertical: sizes.s6),
        alignment: Alignment.center,
        decoration: selected ? _selectedDecoration() : _unselectedDecoration(),
        child: Text(
          text,
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
