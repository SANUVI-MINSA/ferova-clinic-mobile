class CloseConsultationRequestDto {
  final String consultationId;

  const CloseConsultationRequestDto({required this.consultationId});

  Map<String, dynamic> toJson() {
    return {'consultationId': consultationId};
  }
}
