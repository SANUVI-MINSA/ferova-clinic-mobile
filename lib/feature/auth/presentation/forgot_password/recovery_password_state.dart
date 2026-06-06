class RecoveryPasswordState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final String? successMessage;

  RecoveryPasswordState({
    this.isLoading = false,
    this.email,
    this.errorMessage,
    this.successMessage,
  });

  RecoveryPasswordState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
    String? successMessage,
  }) {
    return RecoveryPasswordState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get canSendCode => email != null && email!.contains('@');
}