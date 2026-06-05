class User {
  final String id;
  final String name;
  final String lastname;
  final String email;
  final String dni;
  final String phone;
  final String role; // only Admin or Nurse

  const User({
    required this.id,
    required this.name,
    required this.lastname,
    required this.email,
    required this.dni,
    required this.phone,
    required this.role
  });

  // Get FullName of User
  String get fullName => '$name $lastname';
  bool get isAdmin => role == "Admin";
  bool get isNurse => role == "Nurse";

}