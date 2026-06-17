class DistrictDto {
  final String id;
  final String name;

  const DistrictDto({required this.id, required this.name});

  factory DistrictDto.fromJson(Map<String, dynamic> json) {
    return DistrictDto(id: json['id'] as String, name: json['name'] as String);
  }
}
