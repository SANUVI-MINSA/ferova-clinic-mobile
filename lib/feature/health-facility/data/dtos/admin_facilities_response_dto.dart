class AdminFacilityResponseDto {
  final int total;
  final List<AdminFacilityResponseDto> adminFacilities;

  const AdminFacilityResponseDto({
    required this.total,
    required this.adminFacilities,
  });

  factory AdminFacilityResponseDto.fromJson(Map<String, dynamic> json) {
    return AdminFacilityResponseDto(
      total: json['total'] as int,
      adminFacilities: (json['healthFacilities'] as List)
          .map((item) => AdminFacilityResponseDto.fromJson(item))
          .toList(),
    );
  }
}
