import 'package:equatable/equatable.dart';

sealed class QrGenerationState extends Equatable {
  const QrGenerationState();

  @override
  List<Object?> get props => [];
}

final class QrInitial extends QrGenerationState {
  const QrInitial();
}

final class QrValidating extends QrGenerationState {
  const QrValidating();
}

final class QrGenerationSuccess extends QrGenerationState {
  const QrGenerationSuccess({required this.qrData});
  final String qrData;

  @override
  List<Object?> get props => [qrData];
}

final class QrGenerationFailure extends QrGenerationState {
  const QrGenerationFailure({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
