class GetCheckMedicalRecordResponseDto {
  final String patientId;
  final bool hasMedicalRecord;
  final String? medicalRecordId;

  const GetCheckMedicalRecordResponseDto({
    required this.patientId,
    required this.hasMedicalRecord,
    this.medicalRecordId,
  });

  // ✅ Factory que maneja diferentes formatos de respuesta
  factory GetCheckMedicalRecordResponseDto.fromJson(Map<String, dynamic> json) {
    // 🔍 Log para depuración
    print('📥 GetCheckMedicalRecordResponseDto.fromJson: $json');

    // ✅ Caso 1: La respuesta tiene los campos esperados
    if (json.containsKey('hasMedicalRecord')) {
      return GetCheckMedicalRecordResponseDto(
        patientId: json['patientId']?.toString() ?? '',
        hasMedicalRecord: json['hasMedicalRecord'] as bool? ?? false,
        medicalRecordId: json['medicalRecordId']?.toString(),
      );
    }

    // ✅ Caso 2: La respuesta tiene solo medicalRecordId (si existe, tiene historial)
    if (json.containsKey('medicalRecordId')) {
      final hasRecord = json['medicalRecordId'] != null && json['medicalRecordId']?.toString().isNotEmpty == true;
      return GetCheckMedicalRecordResponseDto(
        patientId: json['patientId']?.toString() ?? '',
        hasMedicalRecord: hasRecord,
        medicalRecordId: json['medicalRecordId']?.toString(),
      );
    }

    // ✅ Caso 3: La respuesta es un objeto con 'data'
    if (json.containsKey('data')) {
      final data = json['data'] as Map<String, dynamic>? ?? {};
      return GetCheckMedicalRecordResponseDto(
        patientId: data['patientId']?.toString() ?? json['patientId']?.toString() ?? '',
        hasMedicalRecord: data['hasMedicalRecord'] as bool? ?? false,
        medicalRecordId: data['medicalRecordId']?.toString(),
      );
    }

    // ✅ Caso 4: Fallback - si no se puede determinar, asumir false
    return GetCheckMedicalRecordResponseDto(
      patientId: json['patientId']?.toString() ?? '',
      hasMedicalRecord: false,
    );
  }
}