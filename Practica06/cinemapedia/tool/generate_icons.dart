// Genera el icono de Cinemapedia dibujando el logo (aro cian + botón de
// reproducción) en código, para que coincida exactamente con el logo de la app
// (lib/presentation/widgets/shared/cinemapedia_logo.dart).
//
// Uso:
//   dart run tool/generate_icons.dart        # crea las imágenes
//   dart run flutter_launcher_icons          # las reparte en cada plataforma
//
// No depende de ninguna imagen externa: todo se dibuja píxel por píxel con
// supermuestreo (SS x SS) para que los bordes queden suaves.

import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Colores del logo (los mismos que en app_theme.dart / cinemapedia_logo.dart).
const List<int> _dark = [0x00, 0x83, 0x8F];
const List<int> _base = [0x00, 0xE5, 0xFF];
const List<int> _light = [0x7D, 0xF9, 0xFF];

/// Relación radio interior / exterior del aro (igual que el painter).
const double _innerRatio = 56 / 120;

/// Supermuestreo por lado (4 => 16 muestras por píxel).
const int _ss = 4;

void main() {
  final iconDir = Directory('assets/icon')..createSync(recursive: true);

  // 1) Icono maestro: fondo negro, se usa en iOS, macOS, web y Windows.
  _write('${iconDir.path}/app_icon.png', _render(1024, outerRatio: 0.34, bg: [0, 0, 0]));
  stdout.writeln('OK assets/icon/app_icon.png');

  // 2) Primer plano para el icono adaptativo de Android (transparente y con
  //    margen, para que la máscara circular no recorte el logo).
  _write('${iconDir.path}/app_icon_foreground.png',
      _render(1024, outerRatio: 0.30, bg: null));
  stdout.writeln('OK assets/icon/app_icon_foreground.png');

  // 3) Logo de la pantalla de arranque nativa de Android en cada densidad,
  //    a 130 dp (el mismo tamaño que el logo del splash de Flutter).
  const densities = <String, double>{
    'mdpi': 1.0,
    'hdpi': 1.5,
    'xhdpi': 2.0,
    'xxhdpi': 3.0,
    'xxxhdpi': 4.0,
  };
  densities.forEach((density, scale) {
    final dir = Directory('android/app/src/main/res/drawable-$density')
      ..createSync(recursive: true);
    final px = (130 * scale).round();
    _write('${dir.path}/splash_logo.png', _render(px, outerRatio: 0.44, bg: null));
    stdout.writeln('OK android/.../drawable-$density/splash_logo.png');
  });

  // 4) Logo de la pantalla de arranque de iOS (1x, 2x y 3x).
  final iosLaunch =
      Directory('ios/Runner/Assets.xcassets/LaunchImage.imageset');
  if (iosLaunch.existsSync()) {
    _write('${iosLaunch.path}/LaunchImage.png', _render(130, outerRatio: 0.44, bg: null));
    _write('${iosLaunch.path}/LaunchImage@2x.png', _render(260, outerRatio: 0.44, bg: null));
    _write('${iosLaunch.path}/LaunchImage@3x.png', _render(390, outerRatio: 0.44, bg: null));
    stdout.writeln('OK ios/.../LaunchImage.imageset');
  }

  stdout.writeln('\nListo. Ahora ejecuta: dart run flutter_launcher_icons');
}

void _write(String path, img.Image image) {
  File(path).writeAsBytesSync(img.encodePng(image));
}

/// Dibuja el logo centrado en un lienzo cuadrado de [size] px.
///
/// - [outerRatio]: radio exterior del aro como fracción del lado.
/// - [bg]: color de fondo `[r,g,b]`, o `null` para fondo transparente.
img.Image _render(int size, {required double outerRatio, required List<int>? bg}) {
  final out = img.Image(width: size, height: size, numChannels: 4);
  final c = size / 2;
  final outer = size * outerRatio;
  final inner = outer * _innerRatio;

  // Vértices del triángulo de "play" (igual que el painter).
  final triR = inner * 0.78;
  final ax = c - triR * 0.5, ay = c - triR;
  final bx = c - triR * 0.5, by = c + triR;
  final cx = c + triR * 0.9, cy = c;

  final samples = _ss * _ss;

  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      double r = 0, g = 0, b = 0, a = 0;

      for (var sy = 0; sy < _ss; sy++) {
        for (var sx = 0; sx < _ss; sx++) {
          final px = x + (sx + 0.5) / _ss;
          final py = y + (sy + 0.5) / _ss;
          final dx = px - c, dy = py - c;
          final dist = math.sqrt(dx * dx + dy * dy);

          List<int>? color;
          if (dist <= outer && dist >= inner) {
            // Aro: el color depende del tramo angular.
            var deg = math.atan2(dy, dx) * 180 / math.pi;
            if (deg < 0) deg += 360;
            color = deg < 120 ? _dark : (deg < 240 ? _base : _light);
          } else if (_inTriangle(px, py, ax, ay, bx, by, cx, cy)) {
            color = _light;
          } else if (bg != null) {
            color = bg;
          }

          if (color != null) {
            r += color[0];
            g += color[1];
            b += color[2];
            a += 1;
          }
        }
      }

      final alpha = a / samples;
      final rr = alpha > 0 ? (r / a).round().clamp(0, 255) : 0;
      final gg = alpha > 0 ? (g / a).round().clamp(0, 255) : 0;
      final bb = alpha > 0 ? (b / a).round().clamp(0, 255) : 0;
      out.setPixelRgba(x, y, rr, gg, bb, (alpha * 255).round().clamp(0, 255));
    }
  }

  return out;
}

bool _inTriangle(double px, double py, double ax, double ay, double bx,
    double by, double cx, double cy) {
  double cross(double x1, double y1, double x2, double y2, double x3, double y3) =>
      (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3);

  final d1 = cross(px, py, ax, ay, bx, by);
  final d2 = cross(px, py, bx, by, cx, cy);
  final d3 = cross(px, py, cx, cy, ax, ay);

  final hasNeg = d1 < 0 || d2 < 0 || d3 < 0;
  final hasPos = d1 > 0 || d2 > 0 || d3 > 0;
  return !(hasNeg && hasPos);
}
