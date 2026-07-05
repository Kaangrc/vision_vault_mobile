import 'package:equatable/equatable.dart';

sealed class PlateOcrState extends Equatable {
  const PlateOcrState();

  @override
  List<Object?> get props => [];
}

final class PlateOcrInitial extends PlateOcrState {
  const PlateOcrInitial();
}

final class PlateOcrProcessing extends PlateOcrState {
  const PlateOcrProcessing();
}

final class PlateOcrSuccess extends PlateOcrState {
  const PlateOcrSuccess(this.plateText);
  final String plateText;

  @override
  List<Object?> get props => [plateText];
}

final class PlateOcrFailure extends PlateOcrState {
  const PlateOcrFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
