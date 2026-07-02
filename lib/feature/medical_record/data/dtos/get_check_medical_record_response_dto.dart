class GetCheckMedicalRecordResponseDto {
  final String patientId;
  final bool hasMedicalRecord;

  const GetCheckMedicalRecordResponseDto({
    required this.patientId,
    required this.hasMedicalRecord,
  });

  factory GetCheckMedicalRecordResponseDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetCheckMedicalRecordResponseDto(
      patientId: json['patientId'] as String,
      hasMedicalRecord: json['hasMedicalRecord'] as bool,
    );
  }
}