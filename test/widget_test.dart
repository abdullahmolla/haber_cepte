import 'package:flutter_test/flutter_test.dart';
import 'package:haber_cepte/app/app.dart';

void main() {
  testWidgets('Haber Cepte splash test', (WidgetTester tester) async {
    await tester.pumpWidget(const HaberCepteApp());

    expect(find.text('Haber Cepte'), findsOneWidget);
  });
}