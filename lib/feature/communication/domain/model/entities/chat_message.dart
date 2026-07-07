enum SenderRole { mother, nurse }

class ChatMessage {
  final String id;
  final String senderId;
  final SenderRole senderRole;
  final String content;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.content,
    required this.sentAt,
  });
}
