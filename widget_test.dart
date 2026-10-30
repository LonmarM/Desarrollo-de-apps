import 'package:flutter_test/flutter_test.dart';
import 'package:inventario_alertas_ustabuca/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Control de Inventario'), findsWidgets);
  });
}
