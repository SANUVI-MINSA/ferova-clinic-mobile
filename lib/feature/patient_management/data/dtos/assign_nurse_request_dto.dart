class AssignNurseRequestDto {
  final String patientId;

  const AssignNurseRequestDto({required this.patientId});

  Map<String, dynamic> toJson() => {'patientId': patientId};
}
