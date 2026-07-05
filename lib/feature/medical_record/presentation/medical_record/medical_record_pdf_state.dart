class MedicalRecordPdfState {
  final bool isDownloadingRecordPdf;
  final String? recordPdfErrorMessage;
  final bool isDownloadingHemoglobinReportPdf;
  final String? hemoglobinReportPdfErrorMessage;

  const MedicalRecordPdfState({
    this.isDownloadingRecordPdf = false,
    this.recordPdfErrorMessage,
    this.isDownloadingHemoglobinReportPdf = false,
    this.hemoglobinReportPdfErrorMessage,
  });

  MedicalRecordPdfState copyWith({
    bool? isDownloadingRecordPdf,
    String? recordPdfErrorMessage,
    bool? isDownloadingHemoglobinReportPdf,
    String? hemoglobinReportPdfErrorMessage,
  }) {
    return MedicalRecordPdfState(
      isDownloadingRecordPdf:
          isDownloadingRecordPdf ?? this.isDownloadingRecordPdf,
      recordPdfErrorMessage: recordPdfErrorMessage,
      isDownloadingHemoglobinReportPdf:
          isDownloadingHemoglobinReportPdf ??
          this.isDownloadingHemoglobinReportPdf,
      hemoglobinReportPdfErrorMessage: hemoglobinReportPdfErrorMessage,
    );
  }
}
