class NurseAssignmentRequestDto {
  final String facilityId;
  final String nurseId;

  NurseAssignmentRequestDto({required this.facilityId, required this.nurseId});

  Map<String, dynamic> toJson() {
    return {'facilityId': facilityId, 'nurseId': nurseId};
  }
}
