import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse_facility.dart';

class NurseFacilityDto {
  final String facilityName;

  const NurseFacilityDto({required this.facilityName});

  factory NurseFacilityDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return NurseFacilityDto(facilityName: data['facilityName'] as String);
  }

  NurseFacility toDomain() => NurseFacility(facilityName: facilityName);
}
