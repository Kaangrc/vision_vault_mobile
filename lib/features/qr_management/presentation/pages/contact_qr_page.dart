import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_cubit.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_state.dart';

class ContactQrPage extends StatelessWidget {
  const ContactQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrGenerationCubit(),
      child: const ContactQrView(),
    );
  }
}

class ContactQrView extends StatefulWidget {
  const ContactQrView({super.key});

  @override
  State<ContactQrView> createState() => _ContactQrViewState();
}

class _ContactQrViewState extends State<ContactQrView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(
      BuildContext context, String label, IconData icon,) {
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
      prefixIcon: Icon(icon, color: theme.colorScheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact QR Code'),
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
                      controller: _nameController,
                      decoration: _buildInputDecoration(
                          context, 'Full Name', Icons.person,),
                      onChanged: (_) {
                        if (state is! QrInitial) {
                          context.read<QrGenerationCubit>().reset();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration(
                          context, 'Phone Number', Icons.phone,),
                      onChanged: (_) {
                        if (state is! QrInitial) {
                          context.read<QrGenerationCubit>().reset();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _buildInputDecoration(
                          context, 'Email (Optional)', Icons.email,),
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
                                  .generateContactQr(
                                    name: _nameController.text,
                                    phone: _phoneController.text,
                                    email: _emailController.text,
                                  );
                            },
                      child: state is QrValidating
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white,),
                            )
                          : const Text('Generate Contact QR'),
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
