import 'package:flutter_test/flutter_test.dart';
import 'package:little_hero/main.dart';

void main() {
  testWidgets('Little Hero home screen opens', (WidgetTester tester) async {
    await tester.pumpWidget(const LittleHeroApp());

    expect(find.text('Little Hero'), findsOneWidget);
    expect(find.text('Alphabet'), findsOneWidget);
    expect(find.text('Numbers'), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);
    expect(find.text('Shapes'), findsOneWidget);
  });
}
