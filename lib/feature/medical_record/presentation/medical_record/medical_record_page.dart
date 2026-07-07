import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_empty_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_patient_card.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_summary_page.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_view_model.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/register_medical_record_page.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/update_medical_record_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../patient_management/presentation/mother_search/mother_search_page.dart';

class MedicalRecordPage extends StatefulWidget {
  final VoidCallback? onGoToPatients;
  const MedicalRecordPage({super.key, this.onGoToPatients});

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicalRecordViewModel>().getNursePatients();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToRegister(String patientId, String patientName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterMedicalRecordPage(patientId: patientId),
      ),
    );
  }

  void _navigateToViewHistory(String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicalRecordSummaryPage(patientId: patientId),
      ),
    );
  }

  void _navigateToUpdateHistory(String patientId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateMedicalRecordPage(patientId: patientId),
      ),
    );
  }

  void _navigateToAssignPatient() {
    // Usar el callback para ir a la pestaña de pacientes
    if (widget.onGoToPatients != null) {
      widget.onGoToPatients!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MedicalRecordViewModel>();
    final MedicalRecordState state = viewModel.state;

    final filteredPatients = state.patients
        .where(
          (patient) => patient.fullName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historial Medico',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D6EA8),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Selecionar Paciente',
                style: TextStyle(fontSize: 14, color: Color(0xFF1A3A5C)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Buscar paciente...',
                  hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9EAFC0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0D6EA8),
                        ),
                      )
                    : state.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${state.errorMessage}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () => viewModel.getNursePatients(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D6EA8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : state.patients.isEmpty
                    ? MedicalRecordEmptyState(
                        onAssignPatient: _navigateToAssignPatient,
                      )
                    : filteredPatients.isEmpty
                    ? Center(
                        child: Text(
                          'No se encontraron pacientes',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: filteredPatients.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final patient = filteredPatients[index];
                          final hasRecord = state.patientHasRecord[patient.id];

                          return MedicalRecordPatientCard(
                            patient: patient,
                            hasRecord: hasRecord,
                            onViewHistory: () =>
                                _navigateToViewHistory(patient.id),
                            onUpdate: () =>
                                _navigateToUpdateHistory(patient.id),
                            onRegister: () => _navigateToRegister(
                              patient.id,
                              patient.fullName,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
