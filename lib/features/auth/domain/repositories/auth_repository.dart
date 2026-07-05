// ignore_for_file: one_member_abstracts
import 'package:fpdart/fpdart.dart';
import 'package:vision_vault_mobile/core/error/failures.dart';

abstract class AuthRepository {
  /// Attempts to authenticate the user biometrically.
  Future<Either<Failure, bool>> authenticate();
}
