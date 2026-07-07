import 'package:flutter/material.dart';

class NoPatientsRegisteredEmptyState extends StatelessWidget {
  const NoPatientsRegisteredEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F7FB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.person_off_rounded,
                color: Color(0xFF0D6EA8),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sin pacientes registrados',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A3A5C),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Esta madre no tiene pacientes registrados todavía.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7D8F),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
