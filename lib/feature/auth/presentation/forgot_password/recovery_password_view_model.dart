
import 'package:ferova_clinic_flutter/feature/auth/presentation/forgot_password/recovery_password_state.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/auth_repository.dart';

class RecoveryPasswordViewModel extends ChangeNotifier {
  final AuthRepository repository;

  RecoveryPasswordViewModel({required this.repository});

  RecoveryPasswordState _state = RecoveryPasswordState();
  RecoveryPasswordState get state => _state;

  void updateEmail(String email) {
    _state = _state.copyWith(email: email);
    notifyListeners();
  }

  Future<bool> sendResetCode() async {
    if (_state.email == null || _state.email!.isEmpty) {
      _state = _state.copyWith(errorMessage: 'Ingrese su correo electrónico');
      notifyListeners();
      return false;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    notifyListeners();

    final result = await repository.requestResetCode(email: _state.email!);

    if (result.success) {
      _state = _state.copyWith(
        isLoading: false,
        successMessage: result.message ?? 'Código enviado correctamente',
        errorMessage: null,
      );
      notifyListeners();
      return true;
    } else {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: result.error ?? 'Error al enviar el código',
        successMessage: null,
      );
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }

  void clearSuccess() {
    _state = _state.copyWith(successMessage: null);
    notifyListeners();
  }
}