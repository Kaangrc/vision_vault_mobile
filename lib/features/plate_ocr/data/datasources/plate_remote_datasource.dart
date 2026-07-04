import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class PlateRemoteDataSource {
  Future<String> recognizeTextFromCameraImage(
      CameraImage cameraImage, CameraController controller,);
  void dispose();
}

class PlateRemoteDataSourceImpl implements PlateRemoteDataSource {
  final TextRecognizer _textRecognizer = TextRecognizer();

  @override
  Future<String> recognizeTextFromCameraImage(
      CameraImage cameraImage, CameraController controller,) async {
    final inputImage = _convertCameraImageToInputImage(cameraImage, controller);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    var text = '';
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        text += '${line.text}\n';
      }
    }
    return text;
  }

  InputImage _convertCameraImageToInputImage(
      CameraImage cameraImage, CameraController controller,) {
    final allBytes = WriteBuffer();
    for (final plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());
    final camera = controller.description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(cameraImage.format.raw as int) ??
            InputImageFormat.nv21;

    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: cameraImage.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void dispose() {
    _textRecognizer.close();
  }
}
