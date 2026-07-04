import 'package:camera/camera.dart';
import 'package:fpdart/fpdart.dart';
import 'package:vision_vault_mobile/core/error/failures.dart';

abstract class AddressRepository {
  /// Extracts an address block from a camera image.
  Future<Either<Failure, String?>> extractAddressFromCameraImage(CameraImage image, CameraController controller);
}
