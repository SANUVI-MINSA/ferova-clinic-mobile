import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/model/patient_monitor.dart';

class AdherenceCard extends StatelessWidget {
  final PatientMonitor patient;

  const AdherenceCard({
    super.key,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = patient.adherencePercentage.toDouble();
    final isGood = percentage >= 80;
    final mainColor = isGood ? const Color(0xFF0D6EA8) : const Color(0xFFD32F2F);

    return Container(
      width: double.infinity,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF0D6EA8).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.bar_chart_rounded,
                  size: 16,
                  color: Color(0xFF0D6EA8),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Adherencia',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3A5C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              const Spacer(),
              _StatColumn(
                label: 'Dosis\nconfirmadas:',
                value: '${patient.totalConfirmed}',
              ),
              const SizedBox(width: 24),
              _StatColumn(
                label: 'Dosis\nomitidas:',
                value: '${patient.totalOmitted}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String value;

  const _StatColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7D8F),
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A5C),
          ),
        ),
      ],
    );
  }
}