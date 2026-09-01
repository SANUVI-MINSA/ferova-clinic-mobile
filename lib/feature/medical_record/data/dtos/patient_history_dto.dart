class PatientHistoryDto {
  final String type;
  final String description;

  const PatientHistoryDto({required this.type, required this.description});

  factory PatientHistoryDto.fromJson(Map<String, dynamic> json) {
    return PatientHistoryDto(
      type: json['type']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'description': description};
  }
}