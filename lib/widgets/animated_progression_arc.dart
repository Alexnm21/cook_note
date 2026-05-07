import 'package:flutter/material.dart';

import '../config/theme/app_colors.dart';

class AnimatedProgressionArc extends StatefulWidget {
  final double progress; // 0.0 a 1.0
  final double size;
  final Duration duration;
  final Color color;

  const AnimatedProgressionArc({
    super.key,
    required this.progress,
    this.size = 200,
    this.duration = const Duration(milliseconds: 800),
    this.color = AppColors.primary,
  });

  @override
  State<AnimatedProgressionArc> createState() => _AnimatedProgressionArcState();
}

class _AnimatedProgressionArcState extends State<AnimatedProgressionArc>
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
  void didUpdateWidget(AnimatedProgressionArc oldWidget) {
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
          size: Size(widget.size, widget.size),
          painter: _ProgressionArcPainter(progress: _animation.value),
        );
      },
    );
  }
}

class _ProgressionArcPainter extends CustomPainter {
  final double progress; // 0.0 a 1.0

  _ProgressionArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    const startAngle = 2.2;
    const sweepAngle = 5.1;

    // Arco de fondo
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Arco de progreso
    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final clampedProgress = progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * clampedProgress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ProgressionArcPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
