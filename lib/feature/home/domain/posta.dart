enum PostaStatus { critico, moderado, bajo }

class Posta {
  final String id;
  final String name;
  final double coveragePercentage;
  final PostaStatus status;
  final String location;
  final double latitude;
  final double longitude;

  const Posta({
    required this.id,
    required this.name,
    required this.coveragePercentage,
    required this.status,
    required this.location,
    this.latitude = -12.046374,
    this.longitude = -77.042793,
  });

  String get statusLabel {
    switch (status) {
      case PostaStatus.critico:
        return 'Crítico';
      case PostaStatus.moderado:
        return 'Moderado';
      case PostaStatus.bajo:
        return 'Bien';
    }
  }

  String get shortName {
    if (name.toLowerCase().startsWith('posta ')) {
      return 'P. ${name.substring(6)}';
    }
    return name;
  }
}
