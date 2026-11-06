import 'package:flutter/material.dart';

/// Tema de la app: **cian neón sobre negro**.
///
/// Es una identidad propia (distinta al morado de la referencia):
/// el esquema nace de una semilla cian y todo lo que Flutter pinta
/// por defecto (puntitos del carrusel, barra inferior, corazón de
/// favoritos, chips, botones) sale en cian.
class AppTheme {

  /// Cian base de la marca.
  static const Color cyan = Color(0xFF00E5FF);

  /// Cian oscuro (sombra / segmentos bajos).
  static const Color cyanDark = Color(0xFF00838F);

  /// Cian claro / neón (brillos y acentos).
  static const Color cyanLight = Color(0xFF7DF9FF);

  /// Color de la puntuación y de las clasificaciones.
  static const Color score = Color(0xFF00E5FF);

  ThemeData getTheme() {

    final colorScheme = ColorScheme.fromSeed(
      seedColor: cyan,
      brightness: Brightness.dark,
      surface: Colors.black,
    ).copyWith(
      primary: cyanLight, // cian neón, buen contraste sobre negro
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
      ),
    );
  }

}
