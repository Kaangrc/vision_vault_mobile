import 'package:fpdart/fpdart.dart';
import 'package:vision_vault_mobile/core/error/failures.dart';

/// A type alias for functional error handling using Result<T>.
typedef Result<T> = Either<Failure, T>;
