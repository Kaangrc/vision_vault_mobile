import 'package:camera/camera.dart';
import 'package:vision_vault_mobile/core/error/result.dart';

abstract class PlateRepository {
  Future<Result<String>> scanPlate(
    CameraImage cameraImage,
    CameraController controller,
  );
  void dispose();
}
