import 'package:camera/camera.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vision_vault_mobile/core/error/failures.dart';
import 'package:vision_vault_mobile/features/address_reader/domain/repositories/address_repository.dart';
import 'package:vision_vault_mobile/features/plate_ocr/data/datasources/plate_remote_datasource.dart';

class AddressRepositoryImpl implements AddressRepository {

  AddressRepositoryImpl({required this.remoteDataSource});
  final PlateRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String?>> extractAddressFromCameraImage(
      CameraImage image, CameraController controller,) async {
    try {
      final text = await remoteDataSource.recognizeTextFromCameraImage(image, controller);

      if (text.isEmpty) {
        return const Right(null);
      }

      // In this showcase, we'll just return the raw text if it looks long enough to be an address
      if (text.length > 15) {
        return Right(text.trim());
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to extract address: $e'));
    }
  }
}
