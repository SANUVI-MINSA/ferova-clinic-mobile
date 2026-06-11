import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../domain/auth_repository.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository repository;
  bool _isLoggingIn = false;

  LoginViewModel({required this.repository});

  LoginState _state = LoginState();
  LoginState get state => _state;

  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  // ⭐ Función para decodificar JWT y extraer el userId
  String? _decodeJwtUserId(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      // Ajustar el padding base64
      String normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }

      final decoded = utf8.decode(base64.decode(normalized));
      final json = jsonDecode(decoded);

      return json['id'] as String? ?? json['motherId'] as String?;
    } catch (e) {
      return null;
    }
  }

  Future<void> login({required String dni, required String password}) async {
    if (_isLoggingIn) return;

    _isLoggingIn = true;

    _state = _state.copyWith(
      isLoading: true,
      errorMessage: null,
      user: null,
      token: null,
    );
    notifyListeners();

    try {
      // 1. Login para obtener el token
      final result = await repository.login(dni: dni, password: password);

      if (result == null) {
        _state = _state.copyWith(
          isLoading: false,
          user: null,
          token: null,
          errorMessage: 'DNI o contraseña incorrectos',
        );
        notifyListeners();
        _messageController.add('DNI o contraseña incorrectos');
        _isLoggingIn = false;
        return;
      }

      // 2. Obtener el token guardado
      final token = await repository.getToken();

      if (token == null) {
        _state = _state.copyWith(
          isLoading: false,
          user: null,
          token: null,
          errorMessage: 'Error al obtener token',
        );
        notifyListeners();
        _isLoggingIn = false;
        return;
      }

      // 3. Decodificar JWT para obtener userId
      final userId = _decodeJwtUserId(token);

      if (userId == null) {
        _state = _state.copyWith(
          isLoading: false,
          user: null,
          token: null,
          errorMessage: 'Token inválido',
        );
        notifyListeners();
        _isLoggingIn = false;
        return;
      }

      // 4. Obtener datos completos del usuario (incluyendo role)
      final user = await repository.getUserById(userId);

      if (user == null) {
        _state = _state.copyWith(
          isLoading: false,
          user: null,
          token: null,
          errorMessage: 'Error al obtener datos del usuario',
        );
        notifyListeners();
        _isLoggingIn = false;
        return;
      }

      // 5. VALIDACIÓN DE ROL - Solo Admin y Nurse pueden entrar
      if (user.role != "Admin" && user.role != "Nurse") {
        // Es Mother u otro rol - rechazar acceso
        await repository.logout();
        _state = _state.copyWith(
          isLoading: false,
          user: null,
          token: null,
          errorMessage: 'ACCESO DENEGADO\n\nFerovaClinic es exclusiva para personal.\n\nTu cuenta es de tipo: ${user.role}\n\nUsa la app FEROVAFAMILY.',
        );
        notifyListeners();
        _messageController.add('ACCESO DENEGADO: Esta app es solo para personal (Admin/Nurse)');
        _isLoggingIn = false;
        return;
      }

      // Admin o Nurse - acceso permitido
      _state = _state.copyWith(
        isLoading: false,
        user: user,
        token: token,
        errorMessage: null,
      );
      notifyListeners();
      _messageController.add('Bienvenido ${user.fullName}');

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