// new_password_view_model.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../../../domain/auth_repository.dart';
import 'new_password_state.dart';

class NewPasswordViewModel extends ChangeNotifier {
  final AuthRepository repository;
  final StreamController<String> _messageStreamController = StreamController<String>.broadcast();

  NewPasswordViewModel({required this.repository});

  NewPasswordState _state = NewPasswordState(
    messageStreamController: StreamController<String>.broadcast(),
  );

  NewPasswordState get state => _state;

  // Exponer el stream de mensajes
  Stream<String> get messageStream => _messageStreamController.stream;

  Future<bool> resetPassword(String email, String code, String newPassword) async {
    // Validaciones básicas
    if (newPassword.length < 8) {
      _showMessage('La contraseña debe tener al menos 8 caracteres', isError: true);
      return false;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    notifyListeners();

    final result = await repository.resetPassword(email: email, code: code, newPassword: newPassword);

    if (result.success) {
      _state = _state.copyWith(
        isLoading: false,
        successMessage: result.message ?? 'Contraseña actualizada correctamente',
        errorMessage: null,
      );
      notifyListeners();
      _showMessage(result.message ?? 'Contraseña actualizada correctamente', isError: false);
      return true;
    } else {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: result.error ?? 'Error al actualizar la contraseña',
        successMessage: null,
      );
      notifyListeners();
      _showMessage(result.error ?? 'Error al actualizar la contraseña', isError: true);
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

  void _showMessage(String message, {bool isError = false}) {
    _messageStreamController.add(message);
  }

  @override
  void dispose() {
    _messageStreamController.close();
    _state.dispose();
    super.dispose();
  }
}