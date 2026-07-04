import 'package:flutter/material.dart';

import '../../domain/model/entities/patient.dart';

class MedicalRecordPatientCard extends StatelessWidget {
  final Patient patient;
  final bool? hasRecord;
  final VoidCallback onViewHistory;
  final VoidCallback onUpdate;
  final VoidCallback onRegister;

  const MedicalRecordPatientCard({
    super.key,
    required this.patient,
    required this.hasRecord,
    required this.onViewHistory,
    required this.onUpdate,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          const SizedBox(width: 12),
          _buildTrailing(),
        ],
      ),
    );
  }

  Widget _buildTrailing() {
    if (hasRecord == null) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF0D6EA8),
        ),
      );
    }

    if (hasRecord == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            onPressed: onViewHistory,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0D6EA8),
              side: const BorderSide(color: Color(0xFF0D6EA8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Ver Historial',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onUpdate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A3A5C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(0, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Actualizar',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onRegister,
      child: const Icon(
        Icons.arrow_forward_rounded,
        color: Color(0xFF0D6EA8),
        size: 24,
      ),
    );
  }
}
