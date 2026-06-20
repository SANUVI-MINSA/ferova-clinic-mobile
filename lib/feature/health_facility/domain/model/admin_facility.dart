class AdminFacility {
  final String id;
  final String name;
  final String address;
  final String? assignedNurseName;
  final bool hasNurseAssigned;
  final String? displayMessage;

  AdminFacility({
    required this.id,
    required this.name,
    required this.address,
    this.assignedNurseName,
    required this.hasNurseAssigned,
    this.displayMessage,
  });
}
