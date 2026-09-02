import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_patients/assignable_patient_tile.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_patients/mother_patients_view_model.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_patients/no_facility_assigned_dialog.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_patients/no_patients_registered_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MotherPatientsPage extends StatefulWidget {
  final String motherId;
  final String motherName;

  const MotherPatientsPage({
    super.key,
    required this.motherId,
    required this.motherName,
  });

  @override
  State<MotherPatientsPage> createState() => _MotherPatientsPageState();
}

class _MotherPatientsPageState extends State<MotherPatientsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatients();
    });
  }

  Future<void> _loadPatients() async {
    try {
      await context.read<MotherPatientsViewModel>().getMotherPatients(
        widget.motherId,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar pacientes: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _assignPatient(String patientId) async {
    final viewModel = context.read<MotherPatientsViewModel>();

    // ✅ Verificar si ya está asignado
    final patient = viewModel.state.patients.firstWhere(
          (p) => p.patientId == patientId,
      orElse: () => throw Exception('Paciente no encontrado'),
    );

    if (patient.isAssigned) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este paciente ya está asignado a una enfermera'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final result = await viewModel.assignNurseToPatient(patientId);

    if (!mounted) {
      return;
    }

    switch (result) {
      case AssignNurseResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Paciente asignado exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case AssignNurseResult.noFacilityAssigned:
        showDialog(
          context: context,
          builder: (_) => const NoFacilityAssignedDialog(),
        );
        break;
      case AssignNurseResult.error:
        final message = viewModel.state.assignErrorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message ?? 'No se pudo asignar el paciente.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MotherPatientsViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F4F8),
        elevation: 0,
        foregroundColor: const Color(0xFF1A3A5C),
        title: Text(
          widget.motherName,
          style: const TextStyle(
            color: Color(0xFF1A3A5C),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: state.isLoading ? null : _loadPatients,
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0D6EA8)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: state.isLoading
              ? const Center(
            child: CircularProgressIndicator(color: Color(0xFF0D6EA8)),
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
                    onPressed: () =>
                        viewModel.getMotherPatients(widget.motherId),
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
              ? const NoPatientsRegisteredEmptyState()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  '${state.patients.length} pacientes | '
                      '${state.patients.where((p) => p.isAssigned).length} asignados',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A3A5C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: state.patients.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final patient = state.patients[index];
                    return AssignablePatientTile(
                      patient: patient,
                      isAssigning: state.isAssigning &&
                          state.assigningPatientId == patient.patientId,
                      onAssign: () => _assignPatient(patient.patientId),
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