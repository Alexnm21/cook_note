import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Widget child;
  final Function() onPressed;
  const CustomButton({
    required this.child,
    required this.onPressed,
    this.color = AppColors.primary,
    super.key,
  });

  factory CustomButton.text({
    required String text,
    required TextStyle textStyle,
    required Function() onPressed,
    Color? color,
  }) {
    return CustomButton(
      onPressed: onPressed,
      color: color ?? AppColors.primary,
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: child,
    );
  }
}
