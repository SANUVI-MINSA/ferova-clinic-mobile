class NurseAssignmentResponseDto {
  final String? message;
  final String? error;

  NurseAssignmentResponseDto({this.message, this.error});

  factory NurseAssignmentResponseDto.fromJson(Map<String, dynamic> json) {
    return NurseAssignmentResponseDto(
      message: json['message'] as String?,
      error: json['error'] as String?,
    );
  }
}
