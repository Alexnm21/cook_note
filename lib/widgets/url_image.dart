import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';
import '../config/theme/styles/base_spaces.dart';
import 'svg_icon.dart';

class UrlImage extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  const UrlImage({
    super.key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: imageUrl.isEmpty
            ? Container(
                padding: paddings.all.s12,
                color: AppColors.primary,
                child: const SvgIcon(
                  icon: "food",
                  color: Colors.white,
                ),
              )
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const SvgIcon(icon: "error");
                },
              ),
      ),
    );
  }
}
