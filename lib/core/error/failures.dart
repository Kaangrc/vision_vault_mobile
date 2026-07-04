import 'package:equatable/equatable.dart';

/// A sealed class representing all possible application failures.
sealed class Failure extends Equatable {
  const Failure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server Error occurred.'});
}

class CameraFailure extends Failure {
  const CameraFailure({super.message = 'Camera initialization failed.'});
}

class OcrFailure extends Failure {
  const OcrFailure({super.message = 'Failed to recognize text from image.'});
}

class QrFailure extends Failure {
  const QrFailure({super.message = 'Failed to process QR code.'});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Failed to read/write local storage.'});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unknown error occurred.'});
}
