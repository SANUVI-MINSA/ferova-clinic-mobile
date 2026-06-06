class NewPasswordState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  NewPasswordState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  NewPasswordState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
  }) {
    return NewPasswordState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  bool get isPasswordValid => false; // Se evaluará en la UI
}