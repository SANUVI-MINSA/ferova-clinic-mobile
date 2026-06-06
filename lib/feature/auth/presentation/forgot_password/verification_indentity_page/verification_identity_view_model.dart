import 'package:flutter/material.dart';
import 'dart:async';
import '../../../domain/auth_repository.dart';
import 'verification_identity_state.dart';

class VerificationIdentityViewModel extends ChangeNotifier {
  final AuthRepository repository;
  final StreamController<String> _messageStreamController = StreamController<String>.broadcast();

  VerificationIdentityViewModel({required this.repository});

  VerificationIdentityState _state = VerificationIdentityState(
    messageStreamController: StreamController<String>.broadcast(),
  );

  VerificationIdentityState get state => _state;

  // Exponer el stream de mensajes
  Stream<String> get messageStream => _messageStreamController.stream;

  Future<bool> verifyCode(String email, String code) async {
    if (code.length != 4) {
      _showMessage('El código debe tener 4 dígitos', isError: true);
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
      _showMessage(result.message ?? 'Código verificado correctamente', isError: false);
      return true;
    } else {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: result.error ?? 'Código inválido o expirado',
        successMessage: null,
        isCodeValid: false,
      );
      notifyListeners();
      _showMessage(result.error ?? 'Código inválido o expirado', isError: true);
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
    _state = VerificationIdentityState(
      messageStreamController: StreamController<String>.broadcast(),
    );
    notifyListeners();
  }

  Future<bool> resendCode(String email) async {
    _state = _state.copyWith(isLoading: true, errorMessage: null);
    notifyListeners();

    final result = await repository.requestResetCode(email: email);

    if (result.success) {
      _state = _state.copyWith(
        isLoading: false,
        successMessage: result.message ?? 'Código reenviado correctamente',
        errorMessage: null,
      );
      notifyListeners();
      _showMessage(result.message ?? 'Código reenviado correctamente', isError: false);
      return true;
    } else {
      _state = _state.copyWith(
        isLoading: false,
        errorMessage: result.error ?? 'Error al reenviar el código',
        successMessage: null,
      );
      notifyListeners();
      _showMessage(result.error ?? 'Error al reenviar el código', isError: true);
      return false;
    }
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