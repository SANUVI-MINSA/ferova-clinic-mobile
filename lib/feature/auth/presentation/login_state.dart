import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  final String token;

  LoginSuccess({required this.user, required this.token});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}