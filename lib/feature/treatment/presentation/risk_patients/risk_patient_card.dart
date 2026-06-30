import 'package:flutter/material.dart';

import '../../domain/model/risk_patient.dart';

class RiskPatientCard extends StatelessWidget {
  final RiskPatient patient;
  final String riskLevel;
  final VoidCallback onTap;

  const RiskPatientCard({
    super.key,
    required this.patient,
    required this.riskLevel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHighRisk = riskLevel == 'HIGH';
    final isMediumRisk = riskLevel == 'MEDIUM';
    final isLowRisk = riskLevel == 'LOW';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            // Avatar con iniciales
            CircleAvatar(
              radius: 28,
              backgroundColor: patient.riskColor.withValues(alpha: 0.15),
              child: Text(
                _getInitials(patient.patientName),
                style: TextStyle(
                  color: patient.riskColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Información del paciente
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        patient.patientName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A3A5C),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: patient.riskColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'SCORE: ${patient.score}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: patient.riskColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (patient.patientAge != null)
                        Text(
                          '${patient.patientAge} años',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7D8F),
                          ),
                        ),
                      if (patient.patientAge != null)
                        const SizedBox(width: 12),
                      // MOSTRAR HORAS SIN CONFIRMAR (SOLO PARA HIGH Y MEDIUM)
                      if (isHighRisk || isMediumRisk)
                        _buildHoursIndicator(patient),
                    ],
                  ),
                ],
              ),
            ),

            // Flecha
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9EAFC0),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ INDICADOR DE HORAS SIN CONFIRMAR (SOLO HORAS)
  Widget _buildHoursIndicator(RiskPatient patient) {
    if (!patient.isPending) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.check_circle_rounded,
              color: Color(0xFF2E7D32),
              size: 14,
            ),
            SizedBox(width: 4),
            Text(
              'Confirmado',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.warning_rounded,
            color: Color(0xFFD32F2F),
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            patient.hoursDisplay, // ✅ Ahora muestra SOLO horas (ej: "144 h")
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFD32F2F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String fullName) {
    if (fullName.trim().isEmpty) return '?';
    final words = fullName.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    if (fullName.length < 2) return fullName.toUpperCase();
    return fullName.substring(0, 2).toUpperCase();
  }
}