import 'dart:async';

class RecoveryPasswordState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final String? successMessage;
  final StreamController<String>? _messageStreamController;

  // Getter para exponer el stream
  Stream<String> get messageStream => _messageStreamController?.stream ?? const Stream.empty();

  RecoveryPasswordState({
    this.isLoading = false,
    this.email,
    this.errorMessage,
    this.successMessage,
    StreamController<String>? messageStreamController,
  }) : _messageStreamController = messageStreamController;

  RecoveryPasswordState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
    String? successMessage,
    StreamController<String>? messageStreamController,
  }) {
    return RecoveryPasswordState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      messageStreamController: messageStreamController ?? _messageStreamController,
    );
  }

  bool get canSendCode => email != null && email!.contains('@');

  void addMessage(String message) {
    _messageStreamController?.add(message);
  }

  void dispose() {
    _messageStreamController?.close();
  }
}