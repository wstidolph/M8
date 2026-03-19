import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../domain/orb_state.dart';

/// A CustomPainter that renders a mystical, hardware-accelerated liquid orb.
class OrbPainter extends CustomPainter {
  final double animationValue;
  final OrbState state;
  final double turbulence;
  final bool isAODMode;
  final double nebulaIntensity;

  OrbPainter({
    required this.animationValue,
    required this.state,
    this.turbulence = 0.0,
    this.isAODMode = false,
    this.nebulaIntensity = 0.3,
  });

  // M8 Aesthetic Design Tokens
  static const Color _electricBlue = Color(0xFF1D4ED8);
  static const Color _softAzure = Color(0xFF60A5FA);

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final intensity = (nebulaIntensity ?? 0.25).clamp(0.0, 1.0); 

    // 1. Foundation Paint
    final basePaint = Paint()
      ..shader = RadialGradient(
        colors: isAODMode 
          ? [Colors.black, Colors.white12] 
          : [const Color(0xFF1D4ED8).withOpacity(0.1 + (0.1 * intensity)), const Color(0xFF0F172A)],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = isAODMode ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = 1.0;

    canvas.drawCircle(center, radius, basePaint);

    // 2. Mystic Pulse (Subtle breathing energy)
    if (!isAODMode) {
      final pulseAlpha = (0.05 + (0.1 * intensity * math.sin(animationValue * 2 * math.pi).abs())).clamp(0.0, 1.0);
      final pulsePaint = Paint()
        ..color = const Color(0xFF3B82F6).withOpacity(pulseAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(center, radius * 0.8, pulsePaint);
    }

    // 3. Liquid Layers (Drawn first)
    if (!isAODMode) {
      _drawWave(canvas, size, animationValue, 0.4 * intensity, const Color(0xFF1D4ED8).withOpacity(0.6));
      _drawWave(canvas, size, animationValue + 0.5, 0.3 * intensity, const Color(0xFF2563EB).withOpacity(0.4));
    }

    // 4. Cosmic Nebula Swirl (Vivid Swirling Aura)
    if (!isAODMode) {
      _drawNebula(canvas, center, radius, intensity);
    }
  }

  void _drawNebula(Canvas canvas, Offset center, double radius, double intensity) {
    // 1. Swirling Gas Layer - Deep Macro Glow
    final nebulaPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFF7C3AED).withOpacity((0.8 * intensity).clamp(0.0, 1.0)),
          const Color(0xFF3B82F6).withOpacity(intensity.clamp(0.0, 1.0)), 
          const Color(0xFFDB2777).withOpacity((0.8 * intensity).clamp(0.0, 1.0)),
          const Color(0xFF7C3AED).withOpacity((0.8 * intensity).clamp(0.0, 1.0)), 
        ],
        stops: const [0.0, 0.4, 0.7, 1.0],
        transform: GradientRotation(animationValue * 2.5 * math.pi), // Faster gas rotation
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0 + (14.5 * intensity) // Massive 18.5px Vivid Strike
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 12 + (20 * intensity));
    
    canvas.drawCircle(center, radius, nebulaPaint);

    // 2. Cosmic filaments (Ultra-high density NASA streamers)
    final filamentCount = (28 * intensity).toInt().clamp(8, 35);
    final filamentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rand = math.Random(1337);
    for (int i = 0; i < filamentCount; i++) {
        // High-frequency "whip" effect for filaments
        final wobble = 0.15 * math.sin(animationValue * 8 * math.pi + i);
        final startAngle = (animationValue * (3.5 + intensity) * math.pi) + (i * math.pi / 7) + wobble;
        final sweepAngle = 0.4 + (0.9 * intensity * math.sin(animationValue * 6 * math.pi + i));
        final arcRadius = radius + (rand.nextDouble() * 18 * intensity - (9 * intensity));
        
        final filamentAlpha = (0.6 * intensity).clamp(0.0, 1.0);
        filamentPaint
          ..strokeWidth = 0.8 + (1.8 * intensity)
          ..color = (i % 3 == 0 
            ? const Color(0xFF60A5FA) 
            : (i % 3 == 1 ? const Color(0xFFC084FC) : const Color(0xFFF472B6))
          ).withOpacity(filamentAlpha);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: arcRadius),
          startAngle,
          sweepAngle,
          false,
          filamentPaint,
        );
    }
  }

  void _drawWave(Canvas canvas, Size size, double animationValue, double amplitudeFactor, Color color) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final safeTurbulence = (turbulence ?? 0.0).clamp(0.0, 1.0);

    final double baseFrequency = 1.0 + (3.0 * safeTurbulence);
    final double baseAmplitude = 5.0 + (15.0 * safeTurbulence);
    final double fillLevel = 0.55;

    final clipPath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.save();
    canvas.clipPath(clipPath);

    final liquidPaint = Paint()..style = PaintingStyle.fill;
    final p = Path();
    
    for (int i = 0; i < 3; i++) {
       p.reset();
       final phase = (animationValue * 2 * math.pi) + (i * math.pi / 2);
       final currentAmplitude = baseAmplitude * (1.0 - (i * 0.2));
       final currentFrequency = baseFrequency * (0.8 + (i * 0.1));

       p.moveTo(0, size.height);
       for (double x = 0; x <= size.width; x += 4.0) {
         final relativeX = x / size.width;
         final y = center.dy + 
                  (radius * (1 - 2 * fillLevel)) +
                  (currentAmplitude * math.sin((relativeX * currentFrequency * 2 * math.pi) + phase));
         p.lineTo(x, y);
       }
       p.lineTo(size.width, size.height);
       p.close();

       final waveAlpha = (0.4 + (i * 0.2)).clamp(0.0, 1.0);
       liquidPaint.color = _electricBlue.withOpacity(waveAlpha);
       canvas.drawPath(p, liquidPaint);
    }

    if (safeTurbulence > 0.3) {
      _drawParticles(canvas, size, center, radius, safeTurbulence);
    }

    canvas.restore();
  }

  void _drawParticles(Canvas canvas, Size size, Offset center, double radius, double safeTurbulence) {
    final rand = math.Random(123);
    final pPaint = Paint()
      ..color = _softAzure.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 20; i++) {
        final angle = (animationValue * 2 * math.pi) + (i * 1.5 * math.pi / 10);
        final dist = (radius * 0.4) + (rand.nextDouble() * radius * 0.5);
        final x = center.dx + (dist * math.cos(angle + (safeTurbulence * i)));
        final y = center.dy + (dist * math.sin(angle * 0.5));
        
        if (math.pow(x - center.dx, 2) + math.pow(y - center.dy, 2) < math.pow(radius, 2)) {
           canvas.drawCircle(Offset(x, y), 2.0 * safeTurbulence, pPaint);
        }
    }
  }

  @override
  bool shouldRepaint(covariant OrbPainter oldDelegate) => true;
}
