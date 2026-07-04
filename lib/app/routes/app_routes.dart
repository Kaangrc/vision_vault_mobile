import 'package:flutter/material.dart';
import 'package:vision_vault_mobile/features/address_reader/presentation/pages/address_reader_page.dart';
import 'package:vision_vault_mobile/features/auth/presentation/pages/auth_gate.dart';
import 'package:vision_vault_mobile/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:vision_vault_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:vision_vault_mobile/features/plate_ocr/presentation/pages/plate_reader_page.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/pages/qr_generator_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String home = '/dashboard';
  static const String qrGenerator = '/qr-generator';
  static const String addressReader = '/address-reader';
  static const String plateReader = '/plate-reader';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthGate());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case home:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case qrGenerator:
        return MaterialPageRoute(builder: (_) => const QrGeneratorPage());
      case addressReader:
        return MaterialPageRoute(builder: (_) => const AddressReaderPage());
      case plateReader:
        return MaterialPageRoute(builder: (_) => const PlateReaderPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found!')),
          ),
        );
    }
  }
}
