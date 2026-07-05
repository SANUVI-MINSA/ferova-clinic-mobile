import 'dart:typed_data';

import 'package:ferova_clinic_flutter/feature/medical_record/domain/repository/medical_record_repository.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_pdf_state.dart';
import 'package:flutter/material.dart';

class MedicalRecordPdfViewModel extends ChangeNotifier {
  final MedicalRecordRepository repository;
  MedicalRecordPdfState state = const MedicalRecordPdfState();

  MedicalRecordPdfViewModel({required this.repository});

  Future<Uint8List?> getMedicalRecordPDF(String id) async {
    state = state.copyWith(
      isDownloadingRecordPdf: true,
      recordPdfErrorMessage: null,
    );
    notifyListeners();

    try {
      final bytes = await repository.getMedicalRecordPDF(id);
      state = state.copyWith(
        isDownloadingRecordPdf: false,
        recordPdfErrorMessage: null,
      );
      notifyListeners();
      return bytes;
    } catch (e) {
      state = state.copyWith(
        isDownloadingRecordPdf: false,
        recordPdfErrorMessage: e.toString(),
      );
      notifyListeners();
      return null;
    }
  }

  Future<Uint8List?> getHemoglobinReportPdf(String medicalRecordId) async {
    state = state.copyWith(
      isDownloadingHemoglobinReportPdf: true,
      hemoglobinReportPdfErrorMessage: null,
    );
    notifyListeners();

    try {
      final bytes = await repository.getHemoglobinReportPdf(medicalRecordId);
      state = state.copyWith(
        isDownloadingHemoglobinReportPdf: false,
        hemoglobinReportPdfErrorMessage: null,
      );
      notifyListeners();
      return bytes;
    } catch (e) {
      state = state.copyWith(
        isDownloadingHemoglobinReportPdf: false,
        hemoglobinReportPdfErrorMessage: e.toString(),
      );
      notifyListeners();
      return null;
    }
  }
}
