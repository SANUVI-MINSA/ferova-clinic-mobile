import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/patient.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/no_medical_records_empty_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_empty_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _titleBlue = Color(0xFF1D4ED8);
const _titleRed = Color(0xFF7C0303);

class HemoglobinControlPage extends StatefulWidget {
  const HemoglobinControlPage({super.key});

  @override
  State<HemoglobinControlPage> createState() => _HemoglobinControlPageState();
}

class _HemoglobinControlPageState extends State<HemoglobinControlPage> {
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

  void _goToMedicalRecord() {
    Navigator.pop(context, true);
  }

  void _navigateToAssignPatient() {
    // TODO: Navegar a la pestaña de Pacientes
  }

  void _navigateToRegisterControl(String patientId) {
    // TODO: Navegar al registro de un nuevo control de hemoglobina
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MedicalRecordViewModel>();
    final MedicalRecordState state = viewModel.state;

    final patientsWithRecord = state.patients
        .where((patient) => state.patientHasRecord[patient.id] == true)
        .toList();

    final filteredPatients = patientsWithRecord
        .where(
          (patient) => patient.fullName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: _titleBlue),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 12),
              const Text.rich(
                TextSpan(
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Control de ', style: TextStyle(color: _titleBlue)),
                    TextSpan(text: 'Hemoglobina', style: TextStyle(color: _titleRed)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Selecionar Paciente con historial medico',
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
                child: _buildBody(
                  context,
                  viewModel,
                  state,
                  patientsWithRecord,
                  filteredPatients,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MedicalRecordViewModel viewModel,
    MedicalRecordState state,
    List<Patient> patientsWithRecord,
    List<Patient> filteredPatients,
  ) {
    if (state.isLoading || state.isCheckingRecords) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D6EA8)),
      );
    }

    if (state.errorMessage != null) {
      return Center(
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
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
      );
    }

    if (state.patients.isEmpty) {
      return MedicalRecordEmptyState(onAssignPatient: _navigateToAssignPatient);
    }

    if (patientsWithRecord.isEmpty) {
      return NoMedicalRecordsEmptyState(
        onGoToMedicalRecord: _goToMedicalRecord,
      );
    }

    if (filteredPatients.isEmpty) {
      return Center(
        child: Text(
          'No se encontraron pacientes',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: filteredPatients.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final patient = filteredPatients[index];
        return _PatientTile(
          patient: patient,
          onTap: () => _navigateToRegisterControl(patient.id),
        );
      },
    );
  }
}

class _PatientTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const _PatientTile({required this.patient, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3FB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF0D6EA8),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                patient.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3A5C),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: Color(0xFF0D6EA8),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
