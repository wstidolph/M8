import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/orb_state.dart';

/// A CustomPainter that renders a mystical, hardware-accelerated liquid orb.
class OrbPainter extends CustomPainter {
  final double animationValue;
  final OrbState state;
  final double turbulence;

  OrbPainter({
    required this.animationValue,
    required this.state,
    required this.turbulence,
  });

  // M8 Aesthetic Design Tokens
  static const Color _deepSpace = Color(0xFF000814);
  static const Color _electricBlue = Color(0xFF1D4ED8);
  static const Color _softAzure = Color(0xFF60A5FA);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    // 1. Draw Background (Deep Space)
    final bgPaint = Paint()
      ..color = _deepSpace
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // 2. Draw Liquid Waves (Electric Blue)
    _drawLiquid(canvas, size, center, radius);

    // 3. Draw Outer Glow (Soft Azure)
    final glowPaint = Paint()
      ..color = _softAzure.withValues(alpha: 0.2 + (0.1 * turbulence))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10.0);
    canvas.drawCircle(center, radius, glowPaint);
  }

  void _drawLiquid(Canvas canvas, Size size, Offset center, double radius) {
    // Wave parameters based on state
    final double baseFrequency = 1.0 + (3.0 * turbulence);
    final double baseAmplitude = 5.0 + (15.0 * turbulence);
    final double fillLevel = 0.55; // Mid-point fill

    // Create a circular clipping path for the liquid
    final clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.save();
    canvas.clipPath(clipPath);

    final liquidPaint = Paint()
      ..color = _electricBlue
      ..style = PaintingStyle.fill;

    // Draw 3 layers of sine waves with different phases
    for (int i = 0; i < 3; i++) {
       final p = Path();
       final phase = (animationValue * 2 * math.pi) + (i * math.pi / 2);
       final currentAmplitude = baseAmplitude * (1.0 - (i * 0.2));
       final currentFrequency = baseFrequency * (0.8 + (i * 0.1));

       p.moveTo(0, size.height);
       for (double x = 0; x <= size.width; x += 2.0) {
         final relativeX = x / size.width;
         final y = center.dy + 
                  (radius * (1 - 2 * fillLevel)) +
                  (currentAmplitude * math.sin((relativeX * currentFrequency * 2 * math.pi) + phase));
         p.lineTo(x, y);
       }
       p.lineTo(size.width, size.height);
       p.lineTo(0, size.height);
       p.close();

       // Adjust opacity for depth effect
       liquidPaint.color = _electricBlue.withValues(alpha: 0.4 + (i * 0.2));
       canvas.drawPath(p, liquidPaint);
    }

    // 4. Glow-Ink Particles (Particle-like trails for US2)
    if (turbulence > 0.3) {
      _drawParticles(canvas, size, center, radius);
    }

    canvas.restore();
  }

  void _drawParticles(Canvas canvas, Size size, Offset center, double radius) {
    final rand = math.Random(123); // Consistent seed for stable trails
    final pPaint = Paint()
      ..color = _softAzure.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
        final angle = (animationValue * 2 * math.pi) + (i * 1.5 * math.pi / 10);
        final dist = (radius * 0.4) + (rand.nextDouble() * radius * 0.5);
        final x = center.dx + (dist * math.cos(angle + (turbulence * i)));
        final y = center.dy + (dist * math.sin(angle * 0.5));
        
        // Only draw if inside orb boundaries
        if (math.pow(x - center.dx, 2) + math.pow(y - center.dy, 2) < math.pow(radius, 2)) {
           canvas.drawCircle(Offset(x, y), 2.0 * turbulence, pPaint);
        }
    }
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.state != state ||
           oldDelegate.turbulence != turbulence;
  }
}
