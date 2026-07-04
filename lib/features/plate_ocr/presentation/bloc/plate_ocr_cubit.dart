import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_vault_mobile/features/plate_ocr/domain/repositories/plate_repository.dart';
import 'package:vision_vault_mobile/features/plate_ocr/presentation/bloc/plate_ocr_state.dart';

class PlateOcrCubit extends Cubit<PlateOcrState> {

  PlateOcrCubit(this._repository) : super(const PlateOcrInitial());
  final PlateRepository _repository;

  Future<void> processCameraImage(CameraImage image, CameraController controller) async {
    if (state is PlateOcrProcessing || state is PlateOcrSuccess) return;

    emit(const PlateOcrProcessing());

    final result = await _repository.scanPlate(image, controller);

    result.fold(
      (failure) {
        emit(PlateOcrFailure(failure.message));
        // Reset to initial to allow next frame to be processed
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!isClosed) emit(const PlateOcrInitial());
        });
      },
      (plateText) {
        if (plateText.isNotEmpty) {
          emit(PlateOcrSuccess(plateText));
        } else {
          // No plate found, go back to initial silently
          emit(const PlateOcrInitial());
        }
      },
    );
  }

  void reset() {
    emit(const PlateOcrInitial());
  }
}
