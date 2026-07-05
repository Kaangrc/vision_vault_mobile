import 'package:bloc_test/bloc_test.dart';
import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vision_vault_mobile/core/error/failures.dart';
import 'package:vision_vault_mobile/features/plate_ocr/domain/repositories/plate_repository.dart';
import 'package:vision_vault_mobile/features/plate_ocr/presentation/bloc/plate_ocr_cubit.dart';
import 'package:vision_vault_mobile/features/plate_ocr/presentation/bloc/plate_ocr_state.dart';

class MockPlateRepository extends Mock implements PlateRepository {}

class FakeCameraImage extends Fake implements CameraImage {}

class FakeCameraController extends Fake implements CameraController {}

void main() {
  late MockPlateRepository mockRepository;
  late PlateOcrCubit cubit;
  late FakeCameraImage fakeImage;
  late FakeCameraController fakeController;

  setUp(() {
    mockRepository = MockPlateRepository();
    cubit = PlateOcrCubit(mockRepository);
    fakeImage = FakeCameraImage();
    fakeController = FakeCameraController();
    registerFallbackValue(fakeImage);
    registerFallbackValue(fakeController);
  });

  tearDown(() {
    cubit.close();
  });

  group('PlateOcrCubit', () {
    test('initial state is PlateOcrInitial', () {
      expect(cubit.state, const PlateOcrInitial());
    });

    blocTest<PlateOcrCubit, PlateOcrState>(
      'emits [PlateOcrProcessing, PlateOcrSuccess] when repository returns a valid plate',
      build: () {
        when(() => mockRepository.scanPlate(any(), any()))
            .thenAnswer((_) async => const Right('34ABC123'));
        return cubit;
      },
      act: (cubit) => cubit.processCameraImage(fakeImage, fakeController),
      expect: () => [
        const PlateOcrProcessing(),
        const PlateOcrSuccess('34ABC123'),
      ],
      verify: (_) {
        verify(() => mockRepository.scanPlate(fakeImage, fakeController))
            .called(1);
      },
    );

    blocTest<PlateOcrCubit, PlateOcrState>(
      'emits [PlateOcrProcessing, PlateOcrInitial] when repository returns empty plate (silent continue)',
      build: () {
        when(() => mockRepository.scanPlate(any(), any()))
            .thenAnswer((_) async => const Right(''));
        return cubit;
      },
      act: (cubit) => cubit.processCameraImage(fakeImage, fakeController),
      expect: () => [
        const PlateOcrProcessing(),
        const PlateOcrInitial(),
      ],
    );

    blocTest<PlateOcrCubit, PlateOcrState>(
      'emits [PlateOcrProcessing, PlateOcrFailure] when repository returns failure',
      build: () {
        when(() => mockRepository.scanPlate(any(), any())).thenAnswer(
          (_) async => const Left(ServerFailure(message: 'Camera error')),
        );
        return cubit;
      },
      act: (cubit) => cubit.processCameraImage(fakeImage, fakeController),
      expect: () => [
        const PlateOcrProcessing(),
        const PlateOcrFailure('Camera error'),
      ],
    );
  });
}
