import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/appointment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ferova_clinic_flutter/core/di/dependency_injection.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login/login_page.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login/login_view_model.dart';

import 'feature/auth/presentation/register/register_view_model.dart';

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
        ChangeNotifierProvider(
          create: (context) => getIt<AppointmentViewModel>(),
        ),
        ChangeNotifierProvider(
          create: (context) => getIt<AdminFacilityViewModel>(),
        ),
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
