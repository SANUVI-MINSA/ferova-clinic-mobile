class ChatMessageDto {
  final String id;
  final String senderId;
  final String senderRole;
  final String content;
  final String sentAt;

  const ChatMessageDto({
    required this.id,
    required this.senderId,
    required this.senderRole,
    required this.content,
    required this.sentAt,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) {
    return ChatMessageDto(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderRole: json['senderRole'] as String,
      content: json['content'] as String,
      sentAt: json['sentAt'] as String,
    );
  }
}
