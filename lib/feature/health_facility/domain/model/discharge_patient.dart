class DischargePatient {
  final String id;
  final String name;
  final String lastName;

  const DischargePatient({
    required this.id,
    required this.name,
    required this.lastName,
  });

  String get fullName => '$name $lastName';
}
