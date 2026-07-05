import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vision_vault_mobile/app/app.dart';

void main() {
  testWidgets('App root smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VisionVaultApp());

    // Verify the root widget is a MaterialApp (App is fundamentally working)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
