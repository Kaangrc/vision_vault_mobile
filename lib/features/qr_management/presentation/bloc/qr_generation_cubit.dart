import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vision_vault_mobile/features/qr_management/presentation/bloc/qr_generation_state.dart';

class QrGenerationCubit extends Cubit<QrGenerationState> {
  QrGenerationCubit() : super(const QrInitial());

  void generateTextQr(String text) {
    if (text.trim().isEmpty) {
      emit(
        const QrGenerationFailure(
          errorMessage: 'Text field cannot be empty.',
        ),
      );
      return;
    }

    emit(const QrValidating());

    Future.delayed(const Duration(milliseconds: 300), () {
      emit(QrGenerationSuccess(qrData: text.trim()));
    });
  }

  void generateUrlQr(String url) {
    if (url.trim().isEmpty) {
      emit(
        const QrGenerationFailure(
          errorMessage: 'URL field cannot be empty.',
        ),
      );
      return;
    }

    final urlPattern = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
      caseSensitive: false,
    );

    if (!urlPattern.hasMatch(url.trim())) {
      emit(
        const QrGenerationFailure(errorMessage: 'Please enter a valid URL.'),
      );
      return;
    }

    emit(const QrValidating());
    Future.delayed(const Duration(milliseconds: 300), () {
      emit(QrGenerationSuccess(qrData: url.trim()));
    });
  }

  void generateContactQr({
    required String name,
    required String phone,
    required String email,
  }) {
    if (name.trim().isEmpty || phone.trim().isEmpty) {
      emit(
        const QrGenerationFailure(
          errorMessage: 'Name and Phone are required.',
        ),
      );
      return;
    }

    emit(const QrValidating());
    Future.delayed(const Duration(milliseconds: 300), () {
      final vCard = '''
BEGIN:VCARD
VERSION:3.0
N:$name
TEL:$phone
EMAIL:$email
END:VCARD
''';
      emit(QrGenerationSuccess(qrData: vCard));
    });
  }

  void reset() {
    emit(const QrInitial());
  }
}
