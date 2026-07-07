import 'package:flutter/material.dart';

const _navy = Color(0xFF1A3A5C);
const _mutedGrey = Color(0xFF6B7D8F);
const _accentBlue = Color(0xFF0D6EA8);

class NoPatientsAssignedEmptyState extends StatelessWidget {
  final String? message;
  final String? detail;

  /// Navigates to the Patients section so the nurse can get patients
  /// assigned. Optional because it crosses feature boundaries; wire it up
  /// from wherever this page is instantiated.
  final VoidCallback? onGoToPatients;

  const NoPatientsAssignedEmptyState({
    super.key,
    this.message,
    this.detail,
    this.onGoToPatients,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.people_outline_rounded,
                color: _accentBlue,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message ?? 'No tienes pacientes asignados',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _navy,
              ),
            ),
            if (detail != null) ...[
              const SizedBox(height: 8),
              Text(
                detail!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: _mutedGrey,
                  height: 1.4,
                ),
              ),
            ],
            if (onGoToPatients != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onGoToPatients,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text(
                  'Asignar pacientes',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
