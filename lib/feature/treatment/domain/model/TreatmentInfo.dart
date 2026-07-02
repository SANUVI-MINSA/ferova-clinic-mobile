class TreatmentInfo {
  final String supplementName;
  final String quantity;
  final String dosingHours;
  final int durationDays;
  final String startDate;
  final String endDate;

  const TreatmentInfo({
    required this.supplementName,
    required this.quantity,
    required this.dosingHours,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
  });

  factory TreatmentInfo.fromJson(Map<String, dynamic> json) {
    return TreatmentInfo(
      supplementName: json['supplementName'] as String? ?? 'No especificado',
      quantity: json['quantity'] as String? ?? '0ml',
      dosingHours: json['dosingHours'] as String? ?? '00:00',
      durationDays: json['durationDays'] as int? ?? 0,
      startDate: json['startDate'] as String? ?? DateTime.now().toIso8601String(),
      endDate: json['endDate'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  String get formattedStartDate {
    try {
      final date = DateTime.parse(startDate);
      return '${date.day.toString().padLeft(2, '0')} de ${_getMonth(date.month)} ${date.year}';
    } catch (e) {
      return startDate;
    }
  }

  String get formattedEndDate {
    try {
      final date = DateTime.parse(endDate);
      return '${date.day.toString().padLeft(2, '0')} de ${_getMonth(date.month)} ${date.year}';
    } catch (e) {
      return endDate;
    }
  }

  String _getMonth(int month) {
    const months = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month];
  }
}