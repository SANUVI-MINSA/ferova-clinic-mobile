// lib/feature/treatment/domain/model/treatment.dart

class Treatment {
  final String? id;
  final String? patientId;
  final String? nurseId;
  final String? supplementName;
  final String? quantity;
  final String? dosingHours;
  final int? durationDays;
  final String? startDate;
  final String? endDate;
  final String? status;
  final int? adherenceScore;
  final int? currentStreak;
  final int? totalConfirmed;
  final int? totalOmitted;
  final int? totalPending;
  final String? completionObservation;
  final String? abandonmentObservation;

  const Treatment({
    this.id,
    this.patientId,
    this.nurseId,
    this.supplementName,
    this.quantity,
    this.dosingHours,
    this.durationDays,
    this.startDate,
    this.endDate,
    this.status,
    this.adherenceScore,
    this.currentStreak,
    this.totalConfirmed,
    this.totalOmitted,
    this.totalPending,
    this.completionObservation,
    this.abandonmentObservation,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] as String?,
      patientId: json['patientId'] as String?,
      nurseId: json['nurseId'] as String?,
      supplementName: json['supplementName'] as String?,
      quantity: json['quantity'] as String?,
      dosingHours: json['dosingHours'] as String?,
      durationDays: json['durationDays'] as int?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      status: json['status'] as String?,
      adherenceScore: json['adherenceScore'] as int?,
      currentStreak: json['currentStreak'] as int?,
      totalConfirmed: json['totalConfirmed'] as int?,
      totalOmitted: json['totalOmitted'] as int?,
      totalPending: json['totalPending'] as int? ?? 0,
      completionObservation: json['completionObservation'] as String?,
      abandonmentObservation: json['abandonmentObservation'] as String?,
    );
  }
}