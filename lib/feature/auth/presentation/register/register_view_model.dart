import 'dart:async';

import 'package:flutter/material.dart';
import '../../domain/auth_repository.dart';
import 'register_state.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository repository;

  RegisterViewModel({required this.repository});

  RegisterState _state = RegisterState();
  RegisterState get state => _state;

  // Stream para manejar mensajes
  final _messageController = StreamController<({bool isSuccess, String message})>.broadcast();
  Stream<({bool isSuccess, String message})> get messageStream => _messageController.stream;

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
      notifyListeners();
      
      // Enviar mensaje de éxito
      _messageController.add((
        isSuccess: true,
        message: '✅ ¡Registro exitoso! El personal ha sido creado correctamente.'
      ));
    } else {
      _state = _state.copyWith(
        isLoading: false,
        user: null,
        successMessage: null,
        errorMessage: result.error ?? '❌ Error al registrar personal',
      );
      notifyListeners();
      
      // Enviar mensaje de error
      _messageController.add((
        isSuccess: false,
        message: result.error ?? '❌ Error al registrar personal'
      ));
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
  
  @override
  void dispose() {
    _messageController.close();
    super.dispose();
  }
}