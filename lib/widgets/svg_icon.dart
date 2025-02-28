import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String icon;
  final double size;
  final Color? color;

  const SvgIcon({super.key, required this.icon, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    String path = 'assets/icons/svg/$icon.svg';
    return SvgPicture.asset(
      path,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      width: size,
      height: size,
    );
  }
}
