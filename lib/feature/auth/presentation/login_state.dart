import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';


class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;
  final String? token;

  LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.user,
    this.token,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
    String? token,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}