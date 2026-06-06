import 'package:flutter/material.dart';
import '../../../domain/auth_repository.dart';
import 'verification_identity_state.dart';

class VerificationIdentityViewModel extends ChangeNotifier {
  final AuthRepository repository;

  VerificationIdentityViewModel({required this.repository});

  VerificationIdentityState _state = VerificationIdentityState();
  VerificationIdentityState get state => _state;

  Future<bool> verifyCode(String email, String code) async {
    if (code.length != 4) {
      _state = _state.copyWith(errorMessage: 'El código debe tener 4 dígitos');
      notifyListeners();
      return false;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    notifyListeners();

    final result = await repository.verifyResetCode(email: email, code: code);

    if (result.success) {
      _state = _state.copyWith(
        isLoading: false,
        successMessage: result.message ?? 'Código verificado correctamente',
        errorMessage: null,
        isCodeValid: true,
      );
      notifyListeners();
      return true;
    } else {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: result.error ?? 'Código inválido o expirado',
        successMessage: null,
        isCodeValid: false,
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

  void reset() {
    _state = VerificationIdentityState();
    notifyListeners();
  }
}