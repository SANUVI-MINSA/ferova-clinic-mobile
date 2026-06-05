import 'package:ferova_clinic_flutter/feature/auth/presentation/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/auth_repository.dart';
import '../domain/user.dart';

class RegisterViewModel extends Cubit<RegisterState> {
  final AuthRepository repository;

  RegisterViewModel({required this.repository}) : super(RegisterInitial());

  Future<void> registerStaff({
    required String name,
    required String lastname,
    required String dni,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    emit(RegisterLoading());

    try {
      final User? user = await repository.registerStaff(
        name: name,
        lastname: lastname,
        dni: dni,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );

      if (user != null) {
        emit(RegisterSuccess(
          user: user,
          message: 'Personal registrado exitosamente',
        ));
      } else {
        emit(RegisterFailure(error: 'Error al registrar personal'));
      }
    } catch (e) {
      emit(RegisterFailure(error: 'Error al registrar: $e'));
    }
  }
}