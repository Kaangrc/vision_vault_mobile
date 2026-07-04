import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_vault_mobile/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  

  Bloc.observer = AppBlocObserver();

  runApp(const VisionVaultApp());
}

/// A global observer for BLoC transitions and errors
class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType} $error');
    super.onError(bloc, error, stackTrace);
  }
}
