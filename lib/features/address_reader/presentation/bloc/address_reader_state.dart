import 'package:equatable/equatable.dart';

sealed class AddressReaderState extends Equatable {
  const AddressReaderState();

  @override
  List<Object?> get props => [];
}

final class AddressReaderInitial extends AddressReaderState {
  const AddressReaderInitial();
}

final class AddressReaderProcessing extends AddressReaderState {
  const AddressReaderProcessing();
}

final class AddressReaderSuccess extends AddressReaderState {
  const AddressReaderSuccess(this.addressText);
  final String addressText;

  @override
  List<Object?> get props => [addressText];
}

final class AddressReaderFailure extends AddressReaderState {
  const AddressReaderFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
