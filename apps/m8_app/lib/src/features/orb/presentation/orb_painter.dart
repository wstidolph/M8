import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/orb_state.dart';

/// A CustomPainter that renders a mystical, hardware-accelerated liquid orb.
class OrbPainter extends CustomPainter {
  final double animationValue;
  final OrbState state;
  final double turbulence;
  final bool isAODMode;

  OrbPainter({
    required this.animationValue,
    required this.state,
    this.turbulence = 0.0,
    this.isAODMode = false,
  });

  // M8 Aesthetic Design Tokens
  static const Color _electricBlue = Color(0xFF1D4ED8);
  static const Color _softAzure = Color(0xFF60A5FA);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Foundation Paint
    final basePaint = Paint()
      ..shader = RadialGradient(
        colors: isAODMode 
          ? [Colors.black, Colors.white12] // Dimmed for AOD
          : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
        stops: const [0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = isAODMode ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, basePaint);

    // 2. Mystic Pulse (Disabled in AOD to save power)
    if (!isAODMode) {
      final pulsePaint = Paint()
        ..color = const Color(0xFF3B82F6).withOpacity(0.1 * (1.0 + math.sin(animationValue * 2 * math.pi)))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(center, radius * 0.8, pulsePaint);
    }

    // 3. Liquid Layers (Disabled/Static in AOD)
    if (!isAODMode) {
      _drawWave(canvas, size, animationValue, 0.4, const Color(0xFF1D4ED8).withOpacity(0.6));
      _drawWave(canvas, size, animationValue + 0.5, 0.3, const Color(0xFF2563EB).withOpacity(0.4));
    }
  }

  void _drawWave(Canvas canvas, Size size, double animationValue, double amplitudeFactor, Color color) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

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
