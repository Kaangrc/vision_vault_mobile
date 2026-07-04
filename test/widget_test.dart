import 'package:flutter_test/flutter_test.dart';
import 'package:vision_vault_mobile/app/app.dart';

void main() {
  testWidgets('Home page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VisionVaultApp());

    expect(find.text('Enterprise Solutions'), findsOneWidget);
    expect(find.text('Available Services'), findsOneWidget);
  });
}
