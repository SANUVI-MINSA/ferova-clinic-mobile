import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login/login_view_model.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/register/register_view_model.dart';
import 'package:ferova_clinic_flutter/feature/home/data/analytics_repository_impl.dart';
import 'package:ferova_clinic_flutter/feature/home/data/analytics_service.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/analytics_repository.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/admin_home/admin_home_view_model.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/estado_postas/estado_postas_view_model.dart';
import '../../feature/auth/data/auth_repository_impl.dart';
import '../../feature/auth/data/auth_service.dart';
import '../../feature/auth/presentation/forgot_password/new_password/new_password_view_model.dart';
import '../../feature/auth/presentation/forgot_password/recovery_password/recovery_password_view_model.dart';
import '../../feature/auth/presentation/forgot_password/verification_indentity_page/verification_identity_view_model.dart';

final getIt = GetIt.instance;

void setup() {
  // 1 Auth
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

  // Forgot Password ViewModels
  getIt.registerFactory<RecoveryPasswordViewModel>(
        () => RecoveryPasswordViewModel(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<VerificationIdentityViewModel>(
        () => VerificationIdentityViewModel(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<NewPasswordViewModel>(
        () => NewPasswordViewModel(repository: getIt<AuthRepository>()),
  );

  // 2 Home / Analytics
  // Services
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());

  // Repositories
  getIt.registerLazySingleton<AnalyticsRepository>(
        () => AnalyticsRepositoryImpl(service: getIt<AnalyticsService>()),
  );

  // ViewModels
  getIt.registerFactory<AdminHomeViewModel>(
        () => AdminHomeViewModel(
          repository: getIt<AnalyticsRepository>(),
          authRepository: getIt<AuthRepository>(),
        ),
  );

  getIt.registerFactory<EstadoPostasViewModel>(
        () => EstadoPostasViewModel(repository: getIt<AnalyticsRepository>()),
  );

  getIt.registerFactory<NurseHomeViewModel>(
        () => NurseHomeViewModel(authRepository: getIt<AuthRepository>()),
  );
}