// Test de humo: verifica que la pantalla de bienvenida de Cinemapedia
// se construya sin errores y muestre el nombre de la app.

import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:cinemapedia/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La pantalla de bienvenida muestra el nombre de la app',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme().getTheme(),
        home: const SplashScreen(),
      ),
    );

    // Se adelanta la animación lo suficiente para que aparezca el título.
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.text('CINEMAPEDIA'), findsOneWidget);
  });
}
