import 'package:flutter/material.dart';
import '../../../domain/auth_repository.dart';
import 'new_password_state.dart';

class NewPasswordViewModel extends ChangeNotifier {
  final AuthRepository repository;

  NewPasswordViewModel({required this.repository});

  NewPasswordState _state = NewPasswordState();
  NewPasswordState get state => _state;

  Future<bool> resetPassword(String email, String code, String newPassword) async {
    // Validaciones básicas
    if (newPassword.length < 8) {
      _state = _state.copyWith(errorMessage: 'La contraseña debe tener al menos 8 caracteres');
      notifyListeners();
      return false;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    notifyListeners();

    final result = await repository.resetPassword(email: email, code: code, newPassword:  newPassword);

    if (result.success) {
      _state = _state.copyWith(
        isLoading: false,
        successMessage: result.message ?? 'Contraseña actualizada correctamente',
        errorMessage: null,
      );
      notifyListeners();
      return true;
    } else {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: result.error ?? 'Error al actualizar la contraseña',
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