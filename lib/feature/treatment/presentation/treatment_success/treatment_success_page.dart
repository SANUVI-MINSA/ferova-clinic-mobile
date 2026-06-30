// lib/feature/treatment/presentation/treatment_success/treatment_success_page.dart

import 'package:ferova_clinic_flutter/feature/treatment/domain/model/treatment.dart';
import 'package:flutter/material.dart';

class TreatmentSuccessPage extends StatelessWidget {
  final String patientName;
  final Treatment? treatment;  // ✅ Puede ser null

  const TreatmentSuccessPage({
    super.key,
    required this.patientName,
    this.treatment,  // ✅ No es required
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Valores por defecto si treatment es null
    final supplementName = treatment?.supplementName ?? 'Suplemento';
    final durationDays = treatment?.durationDays ?? 0;


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 64,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                '¡Tratamiento Iniciado!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A5C),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'El tratamiento de $patientName ha sido activado exitosamente.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7D8F),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Suplemento', supplementName),
                    const Divider(height: 16),
                    _buildSummaryRow('Duración', '$durationDays días')
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                          (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EA8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'IR AL INICIO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7D8F),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A5C),
          ),
        ),
      ],
    );
  }
}