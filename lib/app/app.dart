import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vision_vault_mobile/app/routes/app_routes.dart';
import 'package:vision_vault_mobile/app/theme/app_theme.dart';

class VisionVaultApp extends StatefulWidget {
  const VisionVaultApp({super.key});

  @override
  State<VisionVaultApp> createState() => _VisionVaultAppState();
}

class _VisionVaultAppState extends State<VisionVaultApp>
    with WidgetsBindingObserver {
  bool _isBackground = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _isBackground = state == AppLifecycleState.inactive ||
          state == AppLifecycleState.paused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vision Vault Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: AppRoutes.auth,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      builder: (context, child) {
        return Stack(
          children: [
            if (child != null) child,
            if (_isBackground)
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: Icon(
                      Icons.security_rounded,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
