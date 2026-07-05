import 'package:camera/camera.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vision_vault_mobile/core/error/failures.dart';
import 'package:vision_vault_mobile/core/error/result.dart';
import 'package:vision_vault_mobile/features/plate_ocr/data/datasources/plate_remote_datasource.dart';
import 'package:vision_vault_mobile/features/plate_ocr/domain/repositories/plate_repository.dart';

class PlateRepositoryImpl implements PlateRepository {
  PlateRepositoryImpl({required this.remoteDataSource});
  final PlateRemoteDataSource remoteDataSource;

  @override
  Future<Result<String>> scanPlate(
    CameraImage cameraImage,
    CameraController controller,
  ) async {
    try {
      final text = await remoteDataSource.recognizeTextFromCameraImage(
        cameraImage,
        controller,
      );

      // Domain-specific regex parsing
      final regex = RegExp(r'\b[0-9]{2} [A-Z]{1,3} [0-9]{2,4}\b');
      final matches = regex.allMatches(text);

      if (matches.isNotEmpty) {
        final plate = matches.first.group(0) ?? '';
        if (plate.isNotEmpty) {
          return Right(plate);
        }
      }
      return const Left(OcrFailure(message: 'No valid plate found in frame.'));
    } catch (e) {
      return const Left(
        OcrFailure(message: 'Failed to process camera image for text.'),
      );
    }
  }

  @override
  void dispose() {
    remoteDataSource.dispose();
  }
}
