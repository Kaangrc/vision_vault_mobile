import 'package:fpdart/fpdart.dart';
import 'package:local_auth/local_auth.dart';
import 'package:vision_vault_mobile/core/error/failures.dart';
import 'package:vision_vault_mobile/features/auth/domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();
  final LocalAuthentication _auth;

  @override
  Future<Either<Failure, bool>> authenticate() async {
    try {
      final canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        // Fallback for devices without biometric support
        return const Right(true);
      }

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access the vault',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        return const Right(true);
      } else {
        return const Left(CacheFailure(message: 'Authentication failed'));
      }
    } catch (e) {
      // In a real application, handle specific PlatformExceptions
      return const Left(
        CacheFailure(message: 'Authentication exception occurred'),
      );
    }
  }
}
