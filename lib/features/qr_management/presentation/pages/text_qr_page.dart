import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_cubit.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_state.dart';

class TextQrPage extends StatelessWidget {
  const TextQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrGenerationCubit(),
      child: const TextQrView(),
    );
  }
}

class TextQrView extends StatefulWidget {
  const TextQrView({super.key});

  @override
  State<TextQrView> createState() => _TextQrViewState();
}

class _TextQrViewState extends State<TextQrView> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text QR Code'),
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
                      controller: _textController,
                      decoration:
                          _buildInputDecoration(context, 'Enter your text'),
                      maxLines: 4,
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
                                  .generateTextQr(_textController.text);
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
