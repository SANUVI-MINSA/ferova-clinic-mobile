class AdminFacilityRegistrationRequestDto {
  final String name;
  final String address;
  final String districtId;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final List<String> services;
  final List<String> availableDays;
  final List<String> availableSlots;

  AdminFacilityRegistrationRequestDto({
    required this.name,
    required this.address,
    required this.districtId,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.services,
    required this.availableDays,
    required this.availableSlots,
  });

  Map<String, dynamic> toJson() {
    // ✅ Validar que ningún campo sea null o vacío
    final json = {
      'name': name,
      'address': address,
      'districtId': districtId,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'services': services.isNotEmpty ? services : [],
      'availableDays': availableDays.isNotEmpty ? availableDays : [],
      'availableSlots': availableSlots.isNotEmpty ? availableSlots : [],
    };

    // ✅ Log para depuración
    print('📤 Registrando posta:');
    print('  name: $name');
    print('  address: $address');
    print('  districtId: $districtId');
    print('  latitude: $latitude');
    print('  longitude: $longitude');
    print('  phoneNumber: $phoneNumber');
    print('  services: $services');
    print('  availableDays: $availableDays');
    print('  availableSlots: $availableSlots');

    return json;
  }
}