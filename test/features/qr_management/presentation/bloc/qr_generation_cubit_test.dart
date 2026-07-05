import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_cubit.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_state.dart';

void main() {
  late QrGenerationCubit cubit;

  setUp(() {
    cubit = QrGenerationCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('QrGenerationCubit', () {
    test('initial state is QrInitial', () {
      expect(cubit.state, const QrInitial());
    });

    blocTest<QrGenerationCubit, QrGenerationState>(
      'emits [QrValidating, QrGenerationSuccess] for valid text',
      build: () => cubit,
      act: (cubit) => cubit.generateTextQr('Hello World'),
      wait: const Duration(milliseconds: 400),
      expect: () => [
        const QrValidating(),
        const QrGenerationSuccess(qrData: 'Hello World'),
      ],
    );

    blocTest<QrGenerationCubit, QrGenerationState>(
      'emits [QrFailure] for empty text',
      build: () => cubit,
      act: (cubit) => cubit.generateTextQr('   '),
      expect: () => [
        const QrGenerationFailure(errorMessage: 'Text field cannot be empty.'),
      ],
    );

    blocTest<QrGenerationCubit, QrGenerationState>(
      'emits [QrValidating, QrGenerationSuccess] for valid URL',
      build: () => cubit,
      act: (cubit) => cubit.generateUrlQr('https://example.com'),
      wait: const Duration(milliseconds: 400),
      expect: () => [
        const QrValidating(),
        const QrGenerationSuccess(qrData: 'https://example.com'),
      ],
    );

    blocTest<QrGenerationCubit, QrGenerationState>(
      'emits [QrFailure] for invalid URL',
      build: () => cubit,
      act: (cubit) => cubit.generateUrlQr('not a url'),
      expect: () => [
        const QrGenerationFailure(errorMessage: 'Please enter a valid URL.'),
      ],
    );
  });
}
