class ConsultationDto {
  final String consultationId;
  final String patientId;
  final String patientName;
  final String motherId;
  final String motherName;
  final String nurseId;
  final String nurseName;
  final String lastMessage;
  final String lastMessageDate;
  final String createdAt;
  final int messageCount;

  const ConsultationDto({
    required this.consultationId,
    required this.patientId,
    required this.patientName,
    required this.motherId,
    required this.motherName,
    required this.nurseId,
    required this.nurseName,
    required this.lastMessage,
    required this.lastMessageDate,
    required this.createdAt,
    required this.messageCount,
  });

  factory ConsultationDto.fromJson(Map<String, dynamic> json) {
    return ConsultationDto(
      consultationId: json['consultationId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      motherId: json['motherId'] as String,
      motherName: json['motherName'] as String,
      nurseId: json['nurseId'] as String,
      nurseName: json['nurseName'] as String? ?? '',
      lastMessage: json['lastMessage'] as String,
      lastMessageDate: json['lastMessageDate'] as String,
      createdAt: json['createdAt'] as String,
      messageCount: json['messageCount'] as int,
    );
  }
}
