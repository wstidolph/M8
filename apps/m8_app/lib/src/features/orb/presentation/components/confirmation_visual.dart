import 'package:flutter/material.dart';

/// A confirmation visual for Accept/Reject actions that can be long-pressed.
class ConfirmationVisual extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onConfirm;

  const ConfirmationVisual({
    super.key,
    required this.text,
    required this.color,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    // Zero-trust screen metrics
    final media = MediaQuery.maybeOf(context);
    final width = media?.size.width ?? 360.0;
    final isWatch = width < 320;
    
    return GestureDetector(
      onLongPress: () {
        onConfirm();
      },
      child: CustomPaint(
        painter: _ConfirmationShapePainter(color: color),
        child: Center(
          child: Container(
            width: isWatch ? width * 0.45 : width * 0.55,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      fontFamily: 'Outfit',
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.touch_app,
                  color: Colors.white70,
                  size: 20,
                ),
                const Text(
                   "HOLD TO CONFIRM",
                   style: TextStyle(
                     color: Colors.white70,
                     fontSize: 10,
                     fontWeight: FontWeight.w600,
                     letterSpacing: 1.0,
                     fontFamily: 'Inter',
                   ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmationShapePainter extends CustomPainter {
  final Color color;

  _ConfirmationShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withOpacity(0.9),
          color.withOpacity(0.7),
          color.withOpacity(0.5),
        ],
        stops: const [0.0, 0.6, 1.0],
        center: const Alignment(0.0, -0.2),
        radius: 0.8,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10);

    // Reuse a slightly "squashed" hexagon or rounded rect for confirmation
    final path = Path()..addRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2), 
        width: size.width * 0.75, 
        height: size.height * 0.55
      ),
      const Radius.circular(24)
    ));

    canvas.drawShadow(path, color.withOpacity(0.8), 20, true);
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
