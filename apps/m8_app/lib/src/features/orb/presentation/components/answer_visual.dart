import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The classic floating triangle containing the mystical answer text.
class AnswerVisual extends StatelessWidget {
  final String text;

  const AnswerVisual({
    super.key, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrianglePainter(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            text.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1D4ED8).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.7)
      ..lineTo(size.width * 0.9, size.height * 0.7)
      ..lineTo(size.width * 0.5, size.height * 0.2)
      ..close();

    // Subtle glow on triangle
    canvas.drawShadow(path, const Color(0xFF60A5FA), 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
