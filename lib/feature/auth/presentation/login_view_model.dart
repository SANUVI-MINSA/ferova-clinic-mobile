import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository repository;

  LoginViewModel({required this.repository});

  LoginState _state = LoginState();
  LoginState get state => _state;

  Future<void> login({required String dni, required String password}) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    try {
      final User? user = await repository.login(dni: dni, password: password);
      final String? token = await repository.getToken();

      if (user != null && token != null) {
        _state = _state.copyWith(
          isLoading: false,
          user: user,
          token: token,
          errorMessage: null,
        );
      } else {
        _state = _state.copyWith(
          isLoading: false,
          user: null,
          token: null,
          errorMessage: 'DNI o contraseña incorrectos',
        );
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        user: null,
        token: null,
        errorMessage: 'Error al iniciar sesión: $e',
      );
    }
    notifyListeners();
  }

  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }

  void clearSuccess() {
    _state = _state.copyWith(user: null, token: null);
    notifyListeners();
  }
}