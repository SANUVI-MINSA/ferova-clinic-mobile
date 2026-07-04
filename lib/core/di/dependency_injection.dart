import 'package:ferova_clinic_flutter/feature/health_facility/data/repositories/admin_facility_repository_impl.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/repositories/appointment_repository_impl.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/repositories/nurse_repository_impl.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/services/admin_facility_service.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/services/appointment_service.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/data/services/nurse_service.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/admin_facility_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/appointment_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/repositories/nurse_repository.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/appointment_view_model.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_view_model.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/repositories/treatment_repository_impl.dart';
import 'package:ferova_clinic_flutter/feature/treatment/data/service/treatment_service.dart';
import 'package:ferova_clinic_flutter/feature/treatment/domain/repositories/treatment_repository.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/pending_patients/pending_patients_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/auth_repository.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login/login_view_model.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/register/register_view_model.dart';
import 'package:ferova_clinic_flutter/feature/home/data/analytics_repository_impl.dart';
import 'package:ferova_clinic_flutter/feature/home/data/analytics_service.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/analytics_repository.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/admin_home/admin_home_view_model.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/estado_postas/estado_postas_view_model.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/repository/medical_record_repository_impl.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/data/services/medical_record_service.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/repository/medical_record_repository.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_view_model.dart';
import '../../feature/auth/data/auth_repository_impl.dart';
import '../../feature/auth/data/auth_service.dart';
import '../../feature/auth/presentation/forgot_password/new_password/new_password_view_model.dart';
import '../../feature/auth/presentation/forgot_password/recovery_password/recovery_password_view_model.dart';
import '../../feature/auth/presentation/forgot_password/verification_indentity_page/verification_identity_view_model.dart';
import '../../feature/treatment/presentation/start_treatment/start_treatment_view_model.dart';
import '../../feature/treatment/presentation/treatments_list/treatments_list_view_model.dart';

final getIt = GetIt.instance;

void setup() {
  // 1) Auth
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authService: getIt<AuthService>()),
  );
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<RegisterViewModel>(
    () => RegisterViewModel(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<RecoveryPasswordViewModel>(
    () => RecoveryPasswordViewModel(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<VerificationIdentityViewModel>(
    () => VerificationIdentityViewModel(repository: getIt<AuthRepository>()),
  );
  getIt.registerFactory<NewPasswordViewModel>(
    () => NewPasswordViewModel(repository: getIt<AuthRepository>()),
  );

  // 2) Home / Analytics
  getIt.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
  getIt.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(service: getIt<AnalyticsService>()),
  );
  getIt.registerFactory<AdminHomeViewModel>(
    () => AdminHomeViewModel(
      repository: getIt<AnalyticsRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );
  getIt.registerFactory<EstadoPostasViewModel>(
    () => EstadoPostasViewModel(repository: getIt<AnalyticsRepository>()),
  );

  // 3) Health Facility — Nurse
  getIt.registerLazySingleton<AppointmentService>(() => AppointmentService());
  getIt.registerLazySingleton<AppointmentRepository>(
    () => AppointmentRepositoryImpl(service: getIt<AppointmentService>()),
  );
  getIt.registerFactory<AppointmentViewModel>(
    () => AppointmentViewModel(repository: getIt<AppointmentRepository>()),
  );

  getIt.registerLazySingleton<NurseService>(() => NurseService());
  getIt.registerLazySingleton<NurseRepository>(
    () => NurseRepositoryImpl(service: getIt<NurseService>()),
  );
  getIt.registerFactory<NurseHomeViewModel>(
    () => NurseHomeViewModel(
      authRepository: getIt<AuthRepository>(),
      nurseRepository: getIt<NurseRepository>(),
    ),
  );

  // 4) Health Facility — Admin
  getIt.registerLazySingleton<AdminFacilityService>(
    () => AdminFacilityService(),
  );
  getIt.registerLazySingleton<AdminFacilityRepository>(
    () => AdminFacilityRepositoryImpl(service: getIt<AdminFacilityService>()),
  );
  getIt.registerFactory<AdminFacilityViewModel>(
    () => AdminFacilityViewModel(repository: getIt<AdminFacilityRepository>()),
  );

  // 5) Treatment - Nurse
  getIt.registerLazySingleton<TreatmentService>(() => TreatmentService());

  getIt.registerLazySingleton<TreatmentRepository>(
    () => TreatmentRepositoryImpl(service: getIt<TreatmentService>()),
  );

  getIt.registerFactory<PendingPatientsViewModel>(
    () => PendingPatientsViewModel(repository: getIt<TreatmentRepository>()),
  );

  // Iniciar tratamiento
  getIt.registerFactory<StartTreatmentViewModel>(
    () => StartTreatmentViewModel(
      repository: getIt<TreatmentRepository>(),
      patientId: '', // Placeholder, se actualizará en la página
      patientName: '', // Placeholder, se actualizará en la página
    ),
  );

  // Lista de tratamientos
  getIt.registerFactory<TreatmentsListViewModel>(
    () => TreatmentsListViewModel(repository: getIt<TreatmentRepository>()),
  );

  // 6) Medical Record
  getIt.registerLazySingleton<MedicalRecordService>(
    () => MedicalRecordService(),
  );
  getIt.registerLazySingleton<MedicalRecordRepository>(
    () => MedicalRecordRepositoryImpl(service: getIt<MedicalRecordService>()),
  );
  getIt.registerFactory<MedicalRecordViewModel>(
    () => MedicalRecordViewModel(repository: getIt<MedicalRecordRepository>()),
  );
}
