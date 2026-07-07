class Consultation {
  final String consultationId;
  final String patientId;
  final String patientName;
  final String motherId;
  final String motherName;
  final String nurseId;
  final String nurseName;
  final String lastMessage;
  final DateTime lastMessageDate;
  final DateTime createdAt;
  final int messageCount;

  const Consultation({
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
}
