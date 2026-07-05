import 'package:flutter/material.dart';

const _navy = Color(0xFF1A3A5C);
const _accentBlue = Color(0xFF0D6EA8);
const _mutedGrey = Color(0xFF6B7D8F);
const _labelGrey = Color(0xFF9EAFC0);
const _borderColor = Color(0xFFE2E8F0);
const _cardBg = Color(0xFFF8FAFC);
const _iconChipColor = Color(0xFFE8F3FB);

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
  return '${date.day} ${_monthsEs[date.month - 1]}, ${date.year}';
}

String _formatLevel(double value) {
  return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
}

class HemoglobinControlSuccessPage extends StatelessWidget {
  final String patientName;
  final double hemoglobinLevel;
  final String date;
  final VoidCallback? onReturn;

  const HemoglobinControlSuccessPage({
    super.key,
    required this.patientName,
    required this.hemoglobinLevel,
    required this.date,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          onReturn?.call();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _iconChipColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: _accentBlue,
                    size: 60,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '¡Control de Hemoglobina Creado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'El registro se agregó exitosamente a la curva de '
                  'evolución del paciente.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: _mutedGrey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PACIENTE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _labelGrey,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            color: _accentBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              patientName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _navy,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CONTROL DE HEMOGLOBINA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _labelGrey,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            color: _accentBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${_formatLevel(hemoglobinLevel)} g/dL',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _navy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: _mutedGrey,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _formatDate(date),
                            style: const TextStyle(
                              fontSize: 13,
                              color: _mutedGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    label: const Text(
                      'Regresar',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
