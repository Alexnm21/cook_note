import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/styles/base_text_style.dart';

class CustomInputText extends StatelessWidget {
  final Function(String) onChanged;
  final String title;
  final Widget? icon;
  final String? initialValue;
  final int? maxLines;

  final String? Function(String?)? validator;

  const CustomInputText({
    super.key,
    required this.onChanged,
    required this.title,
    this.icon,
    this.validator,
    this.initialValue,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: baseTextStyle.h2),
            if (validator != null)
              Text(
                '(*)',
                style: baseTextStyle.h2.copyWith(color: AppColors.primary),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          initialValue: initialValue,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
