import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/appointment.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/risk_overview.dart';

abstract class NurseRepository {
  Future<List<Appointment>> getTopAppointments();
  Future<RiskOverview?> getRiskOverview();
  Future<NurseFacility?> getMyFacility();
  Future<int> getActivePatientCount();
}
