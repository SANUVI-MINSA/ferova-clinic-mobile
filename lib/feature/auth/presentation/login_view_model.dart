import 'dart:async';

import 'package:flutter/material.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository repository;
  bool _isLoggingIn = false;

  LoginViewModel({required this.repository});

  LoginState _state = LoginState();
  LoginState get state => _state;

  // Stream para manejar mensajes de manera más limpia
  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  Future<void> login({required String dni, required String password}) async {
    if (_isLoggingIn) return;

    _isLoggingIn = true;

    // Resetear estado antes de login
    _state = _state.copyWith(
      isLoading: true,
      errorMessage: null,
      user: null,
      token: null,
    );
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
        notifyListeners();
        
        // Enviar mensaje de éxito
        _messageController.add('Bienvenido ${user.fullName}');
      } else {
        _state = _state.copyWith(
          isLoading: false,
          user: null,
          token: null,
          errorMessage: 'DNI o contraseña incorrectos',
        );
        notifyListeners();
        
        // Enviar mensaje de error
        _messageController.add('DNI o contraseña incorrectos');
      }
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        user: null,
        token: null,
        errorMessage: 'Error al iniciar sesión: $e',
      );
      notifyListeners();
      _messageController.add('Error al iniciar sesión: $e');
    }

    _isLoggingIn = false;
  }

  void clearError() {
    if (_state.errorMessage != null) {
      _state = _state.copyWith(errorMessage: null);
      notifyListeners();
    }
  }

  void clearSuccess() {
    if (_state.user != null || _state.token != null) {
      _state = _state.copyWith(user: null, token: null);
      notifyListeners();
    }
  }

  void resetState() {
    _state = LoginState();
    notifyListeners();
  }
  
  @override
  void dispose() {
    _messageController.close();
    super.dispose();
  }
}