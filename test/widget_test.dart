import 'package:flutter_test/flutter_test.dart';
import 'package:skinprint/app.dart';

void main() {
  testWidgets('Skinprint app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const SkinprintApp());

    expect(find.text('Skinprint'), findsOneWidget);
  });
}