part of '../view/recipe_form.dart';

class TimeFormPart extends StatelessWidget {
  final int time;
  final Function(int) onChanged;
  const TimeFormPart({super.key, required this.time, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('recipe_form.time'.tr(), style: baseTextStyle.h2),
        spacings.y.s14,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimeButton(
              onTap: () {
                if (time <= 0) return;
                onChanged(time - 5);
              },
              icon: Icons.remove,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '$time ${'core.minutes'.tr().toLowerCase()}',
                style: baseTextStyle.h3,
              ),
            ),
            _TimeButton(
              onTap: () {
                onChanged(time + 5);
              },
              icon: Icons.add,
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeButton extends StatelessWidget {
  final Function() onTap;
  final IconData icon;

  const _TimeButton({
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.all(10),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
