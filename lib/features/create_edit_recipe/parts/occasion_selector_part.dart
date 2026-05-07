part of '../view/recipe_form.dart';

class OccasionSelectorPart extends StatelessWidget {
  final List<Occasion> occasions;
  final Function(Occasion) addOccasion;
  final Function(Occasion) removeOccasion;
  const OccasionSelectorPart({
    super.key,
    required this.occasions,
    required this.addOccasion,
    required this.removeOccasion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('recipe.occasion.title'.tr(), style: baseTextStyle.h2),
        spacings.y.s10,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: Occasion.values
              .map((e) => _OccasionSelector(
                    occasion: e,
                    selected: occasions.contains(e),
                    onChanged: (value) {
                      if (occasions.contains(e)) {
                        removeOccasion(e);
                      } else {
                        addOccasion(e);
                      }
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _OccasionSelector extends StatelessWidget {
  final Occasion occasion;
  final bool selected;
  final Function(Occasion) onChanged;
  const _OccasionSelector({
    required this.occasion,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      value: selected,
      onChanged: (value) {
        onChanged(occasion);
      },
      title: Text('recipe.occasion.${occasion.name}'.tr()),
    );
  }
}
