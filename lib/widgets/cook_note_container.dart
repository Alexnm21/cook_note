import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

class CookNoteContainer extends StatelessWidget {
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool hasShadow;
  final Widget child;
  const CookNoteContainer({
    super.key,
    required this.child,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = Colors.white,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: hasShadow
            ? const [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 32,
                  offset: Offset(0, 12),
                  spreadRadius: -4,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
