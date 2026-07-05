import 'package:flutter/material.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/pages/contact_qr_page.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/pages/text_qr_page.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/pages/url_qr_page.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/widgets/feature_card.dart';

class QrGeneratorPage extends StatelessWidget {
  const QrGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
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
                'Select QR Type',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 16),
              FeatureCard(
                title: 'Contact QR Code',
                icon: Icons.contacts_rounded,
                description: 'Generate a QR code with your contact details',
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ContactQrPage(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FeatureCard(
                title: 'Website URL',
                icon: Icons.link_rounded,
                description: 'Generate a QR code for a web link',
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => const UrlQrPage()),
                ),
              ),
              const SizedBox(height: 8),
              FeatureCard(
                title: 'Custom Text',
                icon: Icons.text_fields_rounded,
                description: 'Generate a QR code containing custom text',
                onTap: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => const TextQrPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
