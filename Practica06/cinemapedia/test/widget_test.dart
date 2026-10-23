// Este test verifica que la app arranque y muestre el home de Cinemapedia.

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cinemapedia/main.dart';

void main() {
  setUpAll(() {
    // En los tests dotenv no se carga desde el archivo .env, así que
    // se inicializa con un valor de prueba para que no truque Environment.
    dotenv.loadFromString(envString: 'THE_MOVIEDB_KEY=valor-de-prueba');
  });

  testWidgets('La app muestra el home de Cinemapedia', (WidgetTester tester) async {
    // Construye la app y carga la ruta inicial ('/').
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    // Verifica que el HomeScreen se muestre con su AppBar.
    expect(find.text('Cinemapedia'), findsOneWidget);
    expect(find.text('valor-de-prueba'), findsOneWidget);
  });
}
