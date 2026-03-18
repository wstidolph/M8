import 'package:flutter/material.dart';
import 'orb_painter.dart';

class OrbView extends StatefulWidget {
  const OrbView({super.key});

  @override
  State<OrbView> createState() => _OrbViewState();
}

class _OrbViewState extends State<OrbView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 4), vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: OrbPainter(animationValue: _controller.value),
          size: const Size(double.infinity, double.infinity),
        );
      },
    );
  }
}
