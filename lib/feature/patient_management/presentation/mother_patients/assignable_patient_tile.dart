import 'package:ferova_clinic_flutter/feature/patient_management/domain/model/entities/assignable_patient.dart';
import 'package:flutter/material.dart';

class AssignablePatientTile extends StatelessWidget {
  final AssignablePatient patient;
  final bool isAssigning;
  final VoidCallback onAssign;

  const AssignablePatientTile({
    super.key,
    required this.patient,
    required this.onAssign,
    this.isAssigning = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnassigned =
        patient.statusAssignment == AssignmentStatus.unassigned;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              patient.gender == 'MALE'
                  ? Icons.boy_rounded
                  : Icons.girl_rounded,
              color: const Color(0xFF0D6EA8),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A5C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isUnassigned ? 'Sin enfermera asignada' : 'Ya asignado',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7D8F),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: isUnassigned && !isAssigning ? onAssign : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EA8),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFCBD5E1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isAssigning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(isUnassigned ? 'Asignar' : 'Asignado'),
            ),
          ),
        ],
      ),
    );
  }
}
