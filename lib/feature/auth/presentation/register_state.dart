import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';

sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;
  final String message;

  RegisterSuccess({required this.user, required this.message});
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});
}