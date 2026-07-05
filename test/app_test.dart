import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision_vault_mobile/app/app.dart';

void main() {
  testWidgets('App root smoke test - Navigates to Onboarding', (WidgetTester tester) async {
    // Provide mock values for SharedPreferences to avoid MissingPluginException
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const VisionVaultApp());
    await tester.pumpAndSettle(); // Wait for navigation and animations to finish

    // Verify OnboardingPage is displayed by checking for its first title
    expect(find.text('Intelligent OCR Engine'), findsOneWidget);
  });
}
