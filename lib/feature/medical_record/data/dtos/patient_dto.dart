class PatientDto {
  final String patientId;
  final String fullName;
  final String gender;
  final String status;

  const PatientDto({
    required this.patientId,
    required this.fullName,
    required this.gender,
    required this.status,
  });

  factory PatientDto.fromJson(Map<String, dynamic> json) {
    // ✅ Manejar todos los casos de null con valores por defecto
    return PatientDto(
      patientId: _getString(json, 'patientId') ??
          _getString(json, 'id') ??
          _getString(json, 'patient_id') ?? '',
      fullName: _getString(json, 'fullName') ??
          _getString(json, 'name') ??
          _getString(json, 'patientName') ?? '',
      gender: _getString(json, 'gender') ??
          _getString(json, 'sex') ?? '',
      status: _getString(json, 'status') ??
          _getString(json, 'estado') ?? '',
    );
  }

  // ✅ Helper para obtener String de forma segura
  static String? _getString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) return null;
    return value.toString();
  }
}