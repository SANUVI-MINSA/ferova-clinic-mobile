import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Cubit<LoginState> {
  final AuthRepository repository;
  LoginViewModel({required this.repository}) : super(LoginInitial());
  
  Future<void> login({required String dni, required String password}) async {
    emit(LoginLoading());
    try {
      
      final User? user = await repository.login(
          dni: dni, 
          password: password,
      );
      
      final token = await repository.getToken();
      
      if (user !=null && token != null) {
        emit(LoginSuccess(user: user, token: token));  
      } else {
        emit(LoginFailure(error: 'DNI o contraseña incorrectos'));
      }
    } catch (e) {
      emit(LoginFailure(error: 'Error al iniciar sesión: $e'));
    }
  }
  
}