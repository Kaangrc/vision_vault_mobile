import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_vault_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:vision_vault_mobile/features/auth/presentation/bloc/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit(this._repository) : super(const AuthInitial());
  final AuthRepository _repository;

  Future<void> authenticate() async {
    emit(const AuthAuthenticating());

    final result = await _repository.authenticate();

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(const AuthAuthenticated()),
    );
  }

  void skipAuthenticationForShowcase() {
    // Used if emulator throws an exception and user wants to bypass
    emit(const AuthAuthenticated());
  }
}
