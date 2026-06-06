import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';

class RegisterState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final User? user;

  RegisterState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.user,
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    User? user,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      user: user ?? this.user,
    );
  }
}