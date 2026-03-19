import 'package:flutter/material.dart';

/// Defines the visual container for an answer manifestation.
enum OrbContainerShape {
  triangle,
  roundedRect,
  mysticScrap,
}

/// A striking, physical-feeling visual for the revealed answer.
class AnswerVisual extends StatelessWidget {
  final String text;
  final OrbContainerShape shape;

  const AnswerVisual({
    super.key,
    required this.text,
    this.shape = OrbContainerShape.triangle,
  });

  @override
  Widget build(BuildContext context) {
    // Zero-trust screen metrics
    final media = MediaQuery.maybeOf(context);
    final width = media?.size.width ?? 360.0;
    final isWatch = width < 320;
    
    return CustomPaint(
      painter: _ShapePainter(shape: shape ?? OrbContainerShape.triangle),
      child: Center(
        child: Container(
          // Safety constraints: Ensure text never touches the convex rounded corners
          width: (shape == OrbContainerShape.triangle) 
            ? (isWatch ? width * 0.32 : width * 0.33)
            : (isWatch ? width * 0.45 : width * 0.55),
          padding: EdgeInsets.only(
            top: (shape == OrbContainerShape.triangle) 
              ? (isWatch ? 38.0 : 48.0) 
              : 0.0,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: SizedBox(
               // Force wrapping before scaling
               width: (shape == OrbContainerShape.triangle) 
                  ? (isWatch ? width * 0.45 : width * 0.52)
                  : (isWatch ? width * 0.55 : width * 0.65),
               child: Text(
                  (text ?? "YES").toUpperCase(),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    height: 1.0,
                    fontFamily: 'Roboto',
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
          ),
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final OrbContainerShape shape;

  _ShapePainter({required this.shape});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF3B82F6),
          const Color(0xFF1D4ED8),
          const Color(0xFF1E3A8A),
        ],
        stops: const [0.0, 0.6, 1.0],
        center: const Alignment(0.0, -0.2),
        radius: 0.8,
      ).createShader(rect)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.8
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = const Color(0xFF60A5FA).withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12);

    final path = _getPathForShape(shape ?? OrbContainerShape.triangle, size);

    canvas.drawShadow(path, const Color(0xFF60A5FA).withOpacity(0.8), 20, true);
    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
    canvas.drawPath(path, strokePaint);
    
    final highlightPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    
    canvas.drawPath(path, highlightPaint);
  }

  Path _getPathForShape(OrbContainerShape shape, Size size) {
    switch (shape) {
      case OrbContainerShape.triangle:
        return _getPerfectRoundedTriangle(size);
      case OrbContainerShape.roundedRect:
        return Path()..addRRect(RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2), 
            width: size.width * 0.7, 
            height: size.height * 0.4
          ),
          const Radius.circular(16)
        ));
      default:
        final path = Path();
        final center = Offset(size.width / 2, size.height / 2);
        final w = size.width * 0.4;
        final h = size.height * 0.25;
        path.moveTo(center.dx - w, center.dy - h + 5);
        path.quadraticBezierTo(center.dx, center.dy - h - 10, center.dx + w, center.dy - h + 2);
        path.lineTo(center.dx + w - 5, center.dy + h - 5);
        path.quadraticBezierTo(center.dx, center.dy + h + 15, center.dx - w + 10, center.dy + h);
        path.close();
        return path;
    }
  }

  Path _getPerfectRoundedTriangle(Size size) {
    const r = 16.0;
    final w = size.width ?? 100.0;
    final h = size.height ?? 100.0;
    
    final p1 = Offset(w * 0.15, h * 0.75); 
    final p2 = Offset(w * 0.85, h * 0.75); 
    final p3 = Offset(w * 0.5, h * 0.15);  

    if ((p2 - p1).distance < r * 2) {
       return Path()..moveTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..lineTo(p3.dx, p3.dy)..close();
    }

    final v12 = (p2 - p1) / (p2 - p1).distance;
    final v13 = (p3 - p1) / (p3 - p1).distance;
    final v21 = (p1 - p2) / (p1 - p2).distance;
    final v23 = (p3 - p2) / (p3 - p2).distance;
    final v31 = (p1 - p3) / (p1 - p3).distance;
    final v32 = (p2 - p3) / (p2 - p3).distance;

    return Path()
      ..moveTo(p1.dx + v12.dx * r, p1.dy + v12.dy * r)
      ..lineTo(p2.dx + v21.dx * r, p2.dy + v21.dy * r)
      ..quadraticBezierTo(p2.dx, p2.dy, p2.dx + v23.dx * r, p2.dy + v23.dy * r)
      ..lineTo(p3.dx + v32.dx * r, p3.dy + v32.dy * r)
      ..quadraticBezierTo(p3.dx, p3.dy, p3.dx + v31.dx * r, p3.dy + v31.dy * r)
      ..lineTo(p1.dx + v13.dx * r, p1.dy + v13.dy * r)
      ..quadraticBezierTo(p1.dx, p1.dy, p1.dx + v12.dx * r, p1.dy + v12.dy * r)
      ..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
