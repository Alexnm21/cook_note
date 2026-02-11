part of '../view/recipe_form.dart';

class PortionSelectorPart extends StatelessWidget {
  final int portions;
  final Function(int) onChanged;
  const PortionSelectorPart({
    super.key,
    this.portions = 1,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('recipe.portions'.tr(), style: baseTextStyle.h2),
        spacings.y.s10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PortionButton(
              onTap: () => onChanged(portions - 1),
              icon: Icons.remove,
            ),
            spacings.x.s20,
            Text('$portions', style: baseTextStyle.h2),
            spacings.x.s20,
            _PortionButton(
              onTap: () => onChanged(portions + 1),
              icon: Icons.add,
            ),
          ],
        ),
      ],
    );
  }
}

class _PortionButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  const _PortionButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(icon),
    );
  }
}
