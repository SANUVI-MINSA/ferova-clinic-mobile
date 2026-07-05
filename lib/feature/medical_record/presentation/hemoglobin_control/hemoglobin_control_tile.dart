import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_control.dart';
import 'package:flutter/material.dart';

const _navy = Color(0xFF1A3A5C);
const _mutedGrey = Color(0xFF6B7D8F);
const _borderColor = Color(0xFFE2E8F0);

const _monthsEs = [
  'Ene',
  'Feb',
  'Mar',
  'Abr',
  'May',
  'Jun',
  'Jul',
  'Ago',
  'Sep',
  'Oct',
  'Nov',
  'Dic',
];

String _formatDate(String isoDate) {
  final date = DateTime.tryParse(isoDate)?.toLocal();
  if (date == null) return '-';
  return '${date.day} DE ${_monthsEs[date.month - 1].toUpperCase()}, ${date.year}';
}

String _formatNumber(num value) {
  return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
}

class _AnemiaStatusStyle {
  final String label;
  final Color background;
  final Color foreground;

  const _AnemiaStatusStyle({
    required this.label,
    required this.background,
    required this.foreground,
  });
}

_AnemiaStatusStyle _anemiaStatusStyle(String anemiaStatus) {
  switch (anemiaStatus.trim().toUpperCase()) {
    case 'CONTROLLED':
    case 'CONTROLADA':
    case 'NORMAL':
      return const _AnemiaStatusStyle(
        label: 'CONTROLADA',
        background: Color(0xFFDCFCE7),
        foreground: Color(0xFF15803D),
      );
    case 'MILD':
    case 'LEVE':
      return const _AnemiaStatusStyle(
        label: 'LEVE',
        background: Color(0xFFFEF9C3),
        foreground: Color(0xFF854D0E),
      );
    case 'MODERATE':
    case 'MODERADA':
      return const _AnemiaStatusStyle(
        label: 'MODERADA',
        background: Color(0xFFFFEDD5),
        foreground: Color(0xFFC2410C),
      );
    case 'SEVERE':
    case 'GRAVE':
      return const _AnemiaStatusStyle(
        label: 'GRAVE',
        background: Color(0xFFFEE2E2),
        foreground: Color(0xFFB91C1C),
      );
    default:
      return _AnemiaStatusStyle(
        label: anemiaStatus.toUpperCase(),
        background: const Color(0xFFF1F5F9),
        foreground: _mutedGrey,
      );
  }
}

class HemoglobinControlTile extends StatelessWidget {
  final HemoglobinControl control;

  const HemoglobinControlTile({super.key, required this.control});

  @override
  Widget build(BuildContext context) {
    final status = _anemiaStatusStyle(control.anemiaStatus);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(control.date),
                  style: const TextStyle(fontSize: 11, color: _mutedGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatNumber(control.hemoglobinLevel)} g/dL',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: status.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
