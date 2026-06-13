import 'package:ferova_clinic_flutter/feature/health-facility/domain/model/admin_facility.dart';

abstract class AdminFacilityRepository {
  Future<List<AdminFacility>> getHealthFacilities();
}
