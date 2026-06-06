import 'dart:async';

class VerificationIdentityState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool isCodeValid;
  final StreamController<String>? _messageStreamController;

  // Getter para exponer el stream
  Stream<String> get messageStream => _messageStreamController?.stream ?? const Stream.empty();

  VerificationIdentityState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isCodeValid = false,
    StreamController<String>? messageStreamController,
  }) : _messageStreamController = messageStreamController;

  VerificationIdentityState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? isCodeValid,
    StreamController<String>? messageStreamController,
  }) {
    return VerificationIdentityState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isCodeValid: isCodeValid ?? this.isCodeValid,
      messageStreamController: messageStreamController ?? _messageStreamController,
    );
  }

  void addMessage(String message) {
    _messageStreamController?.add(message);
  }

  void dispose() {
    _messageStreamController?.close();
  }
}