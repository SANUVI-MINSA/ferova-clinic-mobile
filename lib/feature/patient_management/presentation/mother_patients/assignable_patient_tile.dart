// assignable_patient_tile.dart
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
    // ✅ Usar isAssigned en lugar de comparar directamente
    final bool isAssigned = patient.isAssigned;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAssigned ? Colors.green.shade50 : Colors.white,
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
              color: isAssigned ? Colors.green.shade100 : const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isAssigned ? Icons.check_circle : (patient.gender == 'MALE' ? Icons.boy_rounded : Icons.girl_rounded),
              color: isAssigned ? Colors.green : const Color(0xFF0D6EA8),
              size: 28,
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isAssigned
                            ? Colors.green.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isAssigned ? '✓ Asignado' : 'Sin asignar',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isAssigned
                              ? Colors.green.shade800
                              : Colors.orange.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      patient.gender == 'MALE' ? 'Masculino' : 'Femenino',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isAssigned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 14, color: Colors.green.shade700),
                  const SizedBox(width: 4),
                  Text(
                    'Asignado',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: isAssigning ? null : onAssign,
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
                    : const Text('Asignar'),
              ),
            ),
        ],
      ),
    );
  }
}