import 'package:flutter/material.dart';
import 'package:vision_vault_mobile/app/routes/app_routes.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enterprise Solutions'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            children: [
              const SizedBox(height: 16),
              Text(
                'Available Services',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              FeatureCard(
                title: 'QR Code Hub',
                icon: Icons.qr_code_2_rounded,
                description: 'Generate customized QR codes instantly',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.qrGenerator),
              ),
              const SizedBox(height: 8),
              FeatureCard(
                title: 'Plate OCR Engine',
                icon: Icons.directions_car_rounded,
                description: 'Real-time ML Kit license plate recognition',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.plateReader),
              ),
              const SizedBox(height: 8),
              FeatureCard(
                title: 'Address Reader',
                icon: Icons.my_location_rounded,
                description: 'Extract raw address text via camera',
                onTap: () =>
                    Navigator.pushNamed(context, AppRoutes.addressReader),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
