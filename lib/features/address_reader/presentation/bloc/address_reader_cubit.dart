import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_vault_mobile/features/address_reader/domain/repositories/address_repository.dart';
import 'package:vision_vault_mobile/features/address_reader/presentation/bloc/address_reader_state.dart';

class AddressReaderCubit extends Cubit<AddressReaderState> {
  AddressReaderCubit(this._repository) : super(const AddressReaderInitial());
  final AddressRepository _repository;

  Future<void> processCameraImage(
    CameraImage image,
    CameraController controller,
  ) async {
    if (state is AddressReaderProcessing || state is AddressReaderSuccess) {
      return;
    }

    emit(const AddressReaderProcessing());

    final result =
        await _repository.extractAddressFromCameraImage(image, controller);

    result.fold(
      (failure) {
        emit(AddressReaderFailure(failure.message));
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) emit(const AddressReaderInitial());
        });
      },
      (addressText) {
        if (addressText != null && addressText.isNotEmpty) {
          emit(AddressReaderSuccess(addressText));
        } else {
          emit(const AddressReaderInitial());
        }
      },
    );
  }

  void reset() {
    emit(const AddressReaderInitial());
  }
}
