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

  // Exponer el stream de mensajes
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