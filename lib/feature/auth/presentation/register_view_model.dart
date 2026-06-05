import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import 'register_state.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository repository;

  RegisterViewModel({required this.repository});

  RegisterState _state = RegisterState();
  RegisterState get state => _state;

  Future<void> registerStaff({
    required String name,
    required String lastname,
    required String dni,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    notifyListeners();

    final result = await repository.registerStaff(
      name: name,
      lastname: lastname,
      dni: dni,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );

    if (result.user != null) {
      _state = _state.copyWith(
        isLoading: false,
        user: result.user,
        successMessage: '✅ ¡Registro exitoso! El personal ha sido creado correctamente.',
        errorMessage: null,
      );
    } else {
      _state = _state.copyWith(
        isLoading: false,
        user: null,
        successMessage: null,
        errorMessage: result.error ?? '❌ Error al registrar personal',
      );
    }
    notifyListeners();
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