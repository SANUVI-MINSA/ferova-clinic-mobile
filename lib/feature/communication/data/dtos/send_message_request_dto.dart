class SendMessageRequestDto {
  final String consultationId;
  final String senderId;
  final String senderRole;
  final String content;

  /// `senderRole` is always `"NURSE"` in this app: this is the nurse's
  /// mobile app, so the sender of every message it sends is a nurse.
  const SendMessageRequestDto({
    required this.consultationId,
    required this.senderId,
    required this.content,
  }) : senderRole = 'NURSE';

  Map<String, dynamic> toJson() {
    return {
      'consultationId': consultationId,
      'senderId': senderId,
      'senderRole': senderRole,
      'content': content,
    };
  }
}
