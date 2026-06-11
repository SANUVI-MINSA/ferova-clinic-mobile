class DashboardSummary {
  final int totalActiveFacilities;
  final int totalCriticalFacilities;
  final double globalAdherenceRate;

  const DashboardSummary({
    required this.totalActiveFacilities,
    required this.totalCriticalFacilities,
    required this.globalAdherenceRate,
  });

  static const empty = DashboardSummary(
    totalActiveFacilities: 0,
    totalCriticalFacilities: 0,
    globalAdherenceRate: 0,
  );
}
