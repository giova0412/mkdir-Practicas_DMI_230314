import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Logo de Cinemapedia: un **aro cian** con un **botón de reproducción**
/// dentro (identidad propia, distinta a la "C" de la referencia).
///
/// Es el mismo dibujo del icono de la aplicación. [progress] permite
/// "dibujar" el aro de forma animada y, al final, aparece el triángulo
/// (0 = nada, 1 = completo).
class CinemapediaLogo extends StatelessWidget {
  final double size;
  final double progress;

  const CinemapediaLogo({
    super.key,
    this.size = 28,
    this.progress = 1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: CinemapediaLogoPainter(progress: progress),
    );
  }
}

class CinemapediaLogoPainter extends CustomPainter {
  final double progress;

  CinemapediaLogoPainter({required this.progress});

  static const _base = Color(0xFF00E5FF);
  static const _dark = Color(0xFF00838F);
  static const _light = Color(0xFF7DF9FF);

  // Relación radio interior / exterior del aro.
  static const double _innerRatio = 56 / 120;

  @override
  void paint(Canvas canvas, Size size) {
    final side = math.min(size.width, size.height);
    final outer = side / 2;
    final inner = outer * _innerRatio;

    final center = Offset(size.width / 2, size.height / 2);

    final current = 360 * progress.clamp(0.0, 1.0);

    // El aro se dibuja en tres tramos con distintos tonos de cian.
    final segments = <(double, double, Color)>[
      (0, 120, _dark),
      (120, 240, _base),
      (240, 360, _light),
    ];

    for (final (from, to, color) in segments) {
      final segEnd = math.min(to, current);
      if (segEnd <= from) continue;
      canvas.drawPath(
        _ring(center, outer, inner, from, segEnd),
        Paint()
          ..color = color
          ..isAntiAlias = true,
      );
    }

    // El triángulo de "play" aparece cuando el aro ya casi está completo.
    final t = ((progress - 0.5) / 0.5).clamp(0.0, 1.0);
    if (t > 0) {
      final r = inner * 0.78 * t;
      final path = Path()
        ..moveTo(center.dx - r * 0.5, center.dy - r)
        ..lineTo(center.dx - r * 0.5, center.dy + r)
        ..lineTo(center.dx + r * 0.9, center.dy)
        ..close();
      canvas.drawPath(
        path,
        Paint()
          ..color = _light
          ..isAntiAlias = true,
      );
    }
  }

  Path _ring(Offset c, double outer, double inner, double fromDeg, double toDeg) {
    final a0 = fromDeg * math.pi / 180;
    final sweep = (toDeg - fromDeg) * math.pi / 180;

    final path = Path()
      ..arcTo(Rect.fromCircle(center: c, radius: outer), a0, sweep, true)
      ..arcTo(Rect.fromCircle(center: c, radius: inner), a0 + sweep, -sweep, false)
      ..close();
    return path;
  }

  @override
  bool shouldRepaint(CinemapediaLogoPainter old) => old.progress != progress;
}
