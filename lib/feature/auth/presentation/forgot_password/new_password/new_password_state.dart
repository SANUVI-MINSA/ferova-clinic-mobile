// new_password_state.dart
import 'dart:async';

class NewPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final StreamController<String>? _messageStreamController;

  // Getter para exponer el stream
  Stream<String> get messageStream => _messageStreamController?.stream ?? const Stream.empty();

  NewPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    StreamController<String>? messageStreamController,
  }) : _messageStreamController = messageStreamController;

  NewPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    StreamController<String>? messageStreamController,
  }) {
    return NewPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      messageStreamController: messageStreamController ?? _messageStreamController,
    );
  }

  bool get isPasswordValid => false; // Se evaluará en la UI

  void addMessage(String message) {
    _messageStreamController?.add(message);
  }

  void dispose() {
    _messageStreamController?.close();
  }
}