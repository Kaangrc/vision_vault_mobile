import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({required this.address, super.key});
  final String address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Result'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 80,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 24),
              Text(
                'Address Detected',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    children: [
                      Text(
                        'Extracted Text',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          border: Border.all(
                              color: theme.colorScheme.primary, width: 2,),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          address,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.copy),
                label: const Text('Copy to Clipboard'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Address copied!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),),
                  side: BorderSide(color: theme.colorScheme.primary),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Scan Another'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
