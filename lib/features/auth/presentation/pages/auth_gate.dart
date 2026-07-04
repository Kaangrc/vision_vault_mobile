import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vision_vault_mobile/app/routes/app_routes.dart';
import 'package:vision_vault_mobile/features/auth/data/repositories/local_auth_repository.dart';
import 'package:vision_vault_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:vision_vault_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'dart:async';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(LocalAuthRepository()),
      child: const _AuthGateView(),
    );
  }
}

class _AuthGateView extends StatefulWidget {
  const _AuthGateView();

  @override
  State<_AuthGateView> createState() => _AuthGateViewState();
}

class _AuthGateViewState extends State<_AuthGateView> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('seen_onboarding') ?? false;
    if (!seen) {
      if (!mounted) return;
      unawaited(Navigator.pushReplacementNamed(context, AppRoutes.onboarding));
      return;
    }
    if (mounted) {
      unawaited(context.read<AuthCubit>().authenticate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          unawaited(Navigator.pushReplacementNamed(context, AppRoutes.home));
        } else if (state is AuthFailure) {
          // In a showcase, we might allow bypassing on failure or show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.fingerprint,
                    size: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Vision Vault',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state is AuthAuthenticating || state is AuthInitial)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (state is AuthFailure)
                    ElevatedButton(
                      onPressed: () => context.read<AuthCubit>().authenticate(),
                      child: const Text('Try Again'),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
