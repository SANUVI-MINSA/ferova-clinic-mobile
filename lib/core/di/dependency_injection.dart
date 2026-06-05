import 'package:get_it/get_it.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login_view_model.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/register_view_model.dart';

import '../../feature/auth/data/auth_repository_impl.dart';
import '../../feature/auth/data/auth_service.dart';

final getIt = GetIt.instance;

void setup() {
  // Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(authService: getIt<AuthService>()),
  );

  // ViewModels
  getIt.registerFactory<LoginViewModel>(
        () => LoginViewModel(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(repository: getIt<AuthRepository>()),
  );
}