part of '../view/recipe_form.dart';

class DifficultySelectorPart extends StatelessWidget {
  final Difficulty? difficulty;
  final Function(Difficulty?) onChanged;
  const DifficultySelectorPart({
    super.key,
    this.difficulty,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('recipe.difficulty.title'.tr(), style: baseTextStyle.h2),
        spacings.y.s10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: Difficulty.values
              .map((e) => _DifficultyContainer(
                    isSelected: difficulty == e,
                    difficulty: e,
                    onTap: (value) {
                      if (difficulty == value) {
                        onChanged(null);
                      } else {
                        onChanged(value);
                      }
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _DifficultyContainer extends StatelessWidget {
  final bool isSelected;
  final Difficulty difficulty;
  final Function(Difficulty) onTap;
  const _DifficultyContainer({
    required this.isSelected,
    required this.difficulty,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = isSelected ? Colors.black : Colors.grey;
    Color backgroundColor =
        isSelected ? AppColors.primary.withOpacity(0.3) : Colors.transparent;
    Color textColor = isSelected ? Colors.black : Colors.grey;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(difficulty),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: paddings.x.s5,
          padding: paddings.y.s10,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'recipe.difficulty.${difficulty.name}'.tr(),
            style: baseTextStyle.h3.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
