/// Thrown when the backend reports (404) that the current nurse has no
/// facility assigned by an administrator, so patients cannot be assigned.
class NurseNotAssignedException implements Exception {
  final String message;

  const NurseNotAssignedException(this.message);

  @override
  String toString() => message;
}