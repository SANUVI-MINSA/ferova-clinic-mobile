class VerificationIdentityState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool isCodeValid;

  VerificationIdentityState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isCodeValid = false,
  });

  VerificationIdentityState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool? isCodeValid,
  }) {
    return VerificationIdentityState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      isCodeValid: isCodeValid ?? this.isCodeValid,
    );
  }
}