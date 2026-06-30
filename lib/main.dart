import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/appointment_view_model.dart';
import 'package:ferova_clinic_flutter/feature/home/presentation/nurse_home/nurse_home_view_model.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/pending_patients/pending_patients_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ferova_clinic_flutter/core/di/dependency_injection.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login/login_page.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login/login_view_model.dart';

import 'feature/auth/presentation/register/register_view_model.dart';
import 'feature/treatment/presentation/treatments_list/treatments_list_view_model.dart';

void main() {
  setup(); // ← ESTO ES IMPORTANTE: registrar las dependencias
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => getIt<LoginViewModel>()),
        ChangeNotifierProvider(create: (context) => getIt<RegisterViewModel>()),
        ChangeNotifierProvider(create: (context) => getIt<AppointmentViewModel>(),),
        ChangeNotifierProvider(create: (context) => getIt<AdminFacilityViewModel>(),),
        ChangeNotifierProvider(create: (context) => getIt<NurseHomeViewModel>(),),
        ChangeNotifierProvider(create: (context) => getIt<PendingPatientsViewModel>(),),
        ChangeNotifierProvider(create: (context) => getIt<TreatmentsListViewModel>(),),
      ],
      child: MaterialApp(
        title: 'Ferova Clinic',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const LoginPage(),
      ),
    );
  }
}
