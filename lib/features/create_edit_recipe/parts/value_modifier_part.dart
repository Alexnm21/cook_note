part of '../view/recipe_form.dart';

class ValueModifierPart extends StatelessWidget {
  final String title;
  final int value;
  final Function() add;
  final Function() subtract;
  const ValueModifierPart({
    super.key,
    this.title = '',
    this.value = 0,
    required this.add,
    required this.subtract,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      padding: paddings.all.s16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              style: baseTextStyle.h2.copyWith(
                color: AppColors.textLight,
                fontWeight: FontWeight.w600,
              )),
          spacings.y.s14,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ModifyValueButton(
                onTap: subtract,
                icon: Icons.remove,
                backgroundColor: AppColors.imageSelectionBackground,
                foregroundColor: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '$value',
                  style: baseTextStyle.h3,
                ),
              ),
              _ModifyValueButton(
                onTap: add,
                icon: Icons.add,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModifyValueButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const _ModifyValueButton({
    required this.onTap,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      iconSize: 20,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      icon: Icon(
        icon,
      ),
    );
  }
}
