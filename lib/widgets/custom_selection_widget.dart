import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/styles/base_radius.dart';
import '../config/theme/styles/base_spaces.dart';
import '../config/theme/styles/base_text_style.dart';

class CustomSelectionWidget extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final Function(String) onSelected;
  final double borderRadius;
  const CustomSelectionWidget({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.borderRadius = BaseRadius.xs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: paddings.all.s5,
      margin: paddings.x.s16,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: options
            .map((option) => _ContainerOption(
                option: option,
                isSelected: option == selectedOption,
                onTap: () => onSelected(option),
                borderRadius: borderRadius))
            .toList(),
      ),
    );
  }
}

class _ContainerOption extends StatelessWidget {
  final String option;
  final bool isSelected;
  final Function() onTap;
  final double borderRadius;
  const _ContainerOption({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          alignment: Alignment.center,
          padding: paddings.all.s10,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Text(option,
              style: baseTextStyle.h3
                  .copyWith(color: isSelected ? Colors.white : AppColors.text)),
        ),
      ),
    );
  }
}
