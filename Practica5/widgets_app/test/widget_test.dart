// Basic smoke test for Caja de Widgets (Material 3 + go_router + Riverpod).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:widgets_app/main.dart';

void main() {
  testWidgets('La app arranca en Home con el menú de demos', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MainApp()));
    await tester.pumpAndSettle();

    expect(find.text('Caja de Widgets'), findsWidgets);
    expect(find.text('Botones'), findsOneWidget);
    expect(find.text('Tarjetas'), findsOneWidget);
  });
}
