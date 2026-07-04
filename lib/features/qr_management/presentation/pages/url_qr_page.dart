import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_cubit.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_state.dart';

class UrlQrPage extends StatelessWidget {
  const UrlQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrGenerationCubit(),
      child: const UrlQrView(),
    );
  }
}

class UrlQrView extends StatefulWidget {
  const UrlQrView({super.key});

  @override
  State<UrlQrView> createState() => _UrlQrViewState();
}

class _UrlQrViewState extends State<UrlQrView> {
  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: Icon(Icons.link, color: theme.colorScheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Website URL QR'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<QrGenerationCubit, QrGenerationState>(
          listener: (context, state) {
            if (state is QrGenerationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Theme.of(context).colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),),
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      decoration:
                          _buildInputDecoration(context, 'https://example.com'),
                      onChanged: (_) {
                        if (state is! QrInitial) {
                          context.read<QrGenerationCubit>().reset();
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: state is QrValidating
                          ? null
                          : () {
                              context
                                  .read<QrGenerationCubit>()
                                  .generateUrlQr(_urlController.text);
                            },
                      child: state is QrValidating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white,),
                            )
                          : const Text('Generate QR Code'),
                    ),
                    const SizedBox(height: 32),
                    if (state is QrGenerationSuccess)
                      Center(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: QrImageView(
                              data: state.qrData,
                              size: 200,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
