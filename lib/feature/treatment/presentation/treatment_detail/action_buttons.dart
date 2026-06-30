import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/model/treatment_detail.dart';
import 'abandon_treatment_dialog.dart';
import 'complete_treatment_dialog.dart';

class ActionButtons extends StatelessWidget {
  final TreatmentDetail treatment;
  final Function(String) onComplete;
  final Function(String) onAbandon;

  const ActionButtons({
    super.key,
    required this.treatment,
    required this.onComplete,
    required this.onAbandon,
  });

  @override
  Widget build(BuildContext context) {
    // Solo mostrar botones si el tratamiento está ACTIVO
    if (treatment.status != 'ACTIVE') {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showCompleteDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'MARCAR COMO COMPLETADO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showAbandonDialog(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFC62828),
              side: const BorderSide(color: Color(0xFFC62828)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'REGISTRAR ABANDONO',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCompleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CompleteTreatmentDialog(
        patientName: treatment.patientName,
        supplementName: treatment.supplementName,
        durationDays: treatment.durationDays,
        onConfirm: (observation) {
          onComplete(observation);
        },
      ),
    );
  }

  void _showAbandonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AbandonTreatmentDialog(
        patientName: treatment.patientName,
        onConfirm: (observation) {
          onAbandon(observation);
        },
      ),
    );
  }
}