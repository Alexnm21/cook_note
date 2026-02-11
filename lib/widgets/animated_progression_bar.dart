import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

class AnimatedProgressionBar extends StatefulWidget {
  final double progress; // 0.0 a 1.0
  final double width;
  final double height;
  final Duration duration;
  final Color color;
  final Color backgroundColor;

  const AnimatedProgressionBar({
    super.key,
    required this.progress,
    this.width = 200,
    this.height = 8,
    this.duration = const Duration(milliseconds: 800),
    this.color = AppColors.primary,
    this.backgroundColor = Colors.white,
  });

  @override
  State<AnimatedProgressionBar> createState() => _AnimatedProgressionBarState();
}

class _AnimatedProgressionBarState extends State<AnimatedProgressionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedProgressionBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _ProgressionBarPainter(
            progress: _animation.value,
            color: widget.color,
            backgroundColor: widget.backgroundColor,
          ),
        );
      },
    );
  }
}

class _ProgressionBarPainter extends CustomPainter {
  final double progress; // 0.0 a 1.0
  final Color color;
  final Color backgroundColor;

  _ProgressionBarPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.height / 2;

    // Barra de fondo
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ),
      bgPaint,
    );

    // Barra de progreso
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final clampedProgress = progress.clamp(0.0, 1.0);
    final progressWidth = size.width * clampedProgress;

    if (progressWidth > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, progressWidth, size.height),
          Radius.circular(radius),
        ),
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressionBarPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.backgroundColor != backgroundColor;
}
