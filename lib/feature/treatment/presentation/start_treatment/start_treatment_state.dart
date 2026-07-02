class StartTreatmentState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final String patientId;
  final String patientName;

  // Configuración del tratamiento
  final String supplementName;
  final String quantity;
  final String dosingHours;
  final int durationDays;
  final String? endDate;

  const StartTreatmentState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    required this.patientId,
    required this.patientName,
    this.supplementName = 'Sulfato Ferroso (Gotas)',
    this.quantity = '2ml',
    this.dosingHours = '08:00 AM',
    this.durationDays = 90,
    this.endDate,
  });

  StartTreatmentState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? patientId,
    String? patientName,
    String? supplementName,
    String? quantity,
    String? dosingHours,
    int? durationDays,
    String? endDate,
  }) {
    return StartTreatmentState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      supplementName: supplementName ?? this.supplementName,
      quantity: quantity ?? this.quantity,
      dosingHours: dosingHours ?? this.dosingHours,
      durationDays: durationDays ?? this.durationDays,
      endDate: endDate ?? this.endDate,
    );
  }
}