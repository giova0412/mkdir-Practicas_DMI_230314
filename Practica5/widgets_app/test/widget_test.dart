// Basic smoke test for Widgets App (Material 3 + go_router).
import 'package:flutter_test/flutter_test.dart';

import 'package:widgets_app/main.dart';

void main() {
  testWidgets('App arranca en Home con Flutter + Material 3', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MainApp());
    await tester.pumpAndSettle();

    expect(find.text('Flutter + Material 3'), findsOneWidget);
    expect(find.text('Botones'), findsOneWidget);
    expect(find.text('Tarjetas'), findsOneWidget);
  });
}
