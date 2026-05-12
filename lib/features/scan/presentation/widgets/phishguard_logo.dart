import 'package:flutter/material.dart';

/// PhishGuard brand mark: shield outline with integrated fishing hook — stroke only.
class PhishGuardLogo extends StatelessWidget {
  const PhishGuardLogo({
    super.key,
    this.size = 72,
    this.strokeColor = Colors.white,
    this.strokeWidth,
  });

  final double size;
  final Color strokeColor;
  /// When null, scales with [size].
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'PhishGuard',
      child: CustomPaint(
        size: Size.square(size),
        painter: _PhishGuardLogoPainter(
          color: strokeColor,
          strokeWidth: strokeWidth ?? (size * 0.065).clamp(2.0, 4.5),
        ),
      ),
    );
  }
}

class _PhishGuardLogoPainter extends CustomPainter {
  _PhishGuardLogoPainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Normalized paths in 0–100 space, then scaled.
    final sx = w / 100;
    final sy = h / 100;
    canvas.save();
    canvas.scale(sx, sy);

    final shield = Path()
      ..moveTo(50, 7)
      ..cubicTo(28, 9, 14, 28, 14, 48)
      ..quadraticBezierTo(14, 68, 50, 93)
      ..quadraticBezierTo(86, 68, 86, 48)
      ..cubicTo(86, 28, 72, 9, 50, 7)
      ..close();

    // Hook: curves along the right inner shield, open stroke (no fill).
    final hook = Path()
      ..moveTo(74, 26)
      ..cubicTo(80, 38, 78, 58, 58, 72)
      ..quadraticBezierTo(48, 80, 40, 72)
      // Barb
      ..moveTo(40, 72)
      ..lineTo(46, 66);

    canvas.drawPath(shield, paint);
    canvas.drawPath(hook, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PhishGuardLogoPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
