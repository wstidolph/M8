import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrbPainter extends CustomPainter {
  final double animationValue;

  OrbPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // 1. Draw the outer glow
    final outerGlowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.blue.withValues(alpha: 0.5),
          Colors.blue.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.2));
    
    canvas.drawCircle(center, radius * 1.2, outerGlowPaint);

    // 2. Draw the orb background (deep dark blue/black)
    final orbBgPaint = Paint()
      ..color = const Color(0xFF000814);
    canvas.drawCircle(center, radius, orbBgPaint);

    // 3. Draw the liquid simulation (simplified for now)
    final liquidPath = Path();
    final horizontalFactor = math.sin(animationValue * 2 * math.pi) * 10;
    
    liquidPath.moveTo(0, size.height);
    for (double i = 0; i <= size.width; i++) {
      liquidPath.lineTo(
        i,
        size.height / 2 + math.sin((i / size.width * 2 * math.pi) + (animationValue * 2 * math.pi)) * 5 + horizontalFactor,
      );
    }
    liquidPath.lineTo(size.width, size.height);
    liquidPath.close();

    // Clip the liquid to the orb
    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));
    
    final liquidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blue.shade900.withValues(alpha: 0.8),
          Colors.blue.shade400.withValues(alpha: 0.5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(liquidPath, liquidPaint);
    canvas.restore();

    // 4. Draw the answer window (the triangle area)
    final windowRadius = radius * 0.4;
    final windowPaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.2)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(center, windowRadius, windowPaint);

    // 5. Draw a subtle reflection/highlight
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    
    canvas.drawCircle(center, radius, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
