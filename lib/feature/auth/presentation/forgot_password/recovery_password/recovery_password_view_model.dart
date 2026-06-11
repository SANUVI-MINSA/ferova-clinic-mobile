import 'package:flutter/cupertino.dart';
import 'dart:async';
import '../../../domain/auth_repository.dart';
import 'recovery_password_state.dart';

class RecoveryPasswordViewModel extends ChangeNotifier {
  final AuthRepository repository;
  final StreamController<String> _messageStreamController = StreamController<String>.broadcast();

  RecoveryPasswordViewModel({required this.repository});

  RecoveryPasswordState _state = RecoveryPasswordState(
    messageStreamController: StreamController<String>.broadcast(),
  );

  RecoveryPasswordState get state => _state;

  Stream<String> get messageStream => _messageStreamController.stream;

  void updateEmail(String email) {
    _state = _state.copyWith(email: email);
    notifyListeners();
  }

  Future<bool> sendResetCode() async {
    if (_state.email == null || _state.email!.isEmpty) {
      _showMessage('Ingrese su correo electrónico');
      return false;
    }

    if (!_state.email!.contains('@')) {
      _showMessage('Ingrese un correo electrónico válido');
      return false;
    }

    _state = _state.copyWith(isLoading: true, errorMessage: null, successMessage: null);
    notifyListeners();

    // Primero validar el rol del usuario
    final userData = await repository.getUserByEmail(_state.email!);

    if (userData == null) {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'Correo no registrado en el sistema',
        successMessage: null,
      );
      notifyListeners();
      _showMessage('Correo no registrado en el sistema', isError: true);
      return false;
    }

    final userRole = userData['role'] as String? ?? '';

    // VALIDACIÓN DE ROL - Solo Admin y Nurse pueden recuperar
    if (userRole == "Mother") {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: 'ACCESO DENEGADO\n\nEste correo pertenece a una Madre.\nLa recuperación de contraseña es solo para personal (Admin/Nurse).\n\nUsa la app FEROVAFAMILY.',
        successMessage: null,
      );
      notifyListeners();
      _showMessage('ACCESO DENEGADO: Esta función es solo para personal', isError: true);
      return false;
    }

    // Es Admin o Nurse, proceder con el envío del código
    final result = await repository.requestResetCode(email: _state.email!);

    if (result.success) {
      _state = _state.copyWith(
        isLoading: false,
        successMessage: result.message ?? 'Código enviado correctamente',
        errorMessage: null,
      );
      notifyListeners();
      _showMessage(result.message ?? 'Código enviado correctamente', isError: false);
      return true;
    } else {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: result.error ?? 'Error al enviar el código',
        successMessage: null,
      );
      notifyListeners();
      _showMessage(result.error ?? 'Error al enviar el código', isError: true);
      return false;
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    _messageStreamController.add(message);
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
    _messageStreamController.close();
    _state.dispose();
    super.dispose();
  }
}