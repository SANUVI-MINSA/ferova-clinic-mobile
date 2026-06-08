import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:flutter/cupertino.dart';

/// ViewModel para la pantalla principal de Enfermería
///
/// Responsabilidades:
/// - Cargar datos iniciales del nurse (pacientes, citas, etc.)
/// - Manejar el estado de carga y errores
/// - Proveer métodos para actualizar datos (refresh)
/// - Gestionar logout
class NurseHomeViewModel extends ChangeNotifier{
  final AuthRepository authRepository;

  NurseHomeViewModel({required this.authRepository});

  Future<void> logout() async {
    await authRepository.logout();
  }
}