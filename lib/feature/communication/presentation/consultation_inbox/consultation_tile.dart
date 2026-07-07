import 'package:ferova_clinic_flutter/feature/communication/domain/model/entities/consultation.dart';
import 'package:flutter/material.dart';

const _accentBlue = Color(0xFF0D6EA8);
const _navy = Color(0xFF1A3A5C);
const _mutedGrey = Color(0xFF6B7D8F);

class ConsultationTile extends StatelessWidget {
  final Consultation consultation;
  final VoidCallback onTap;

  const ConsultationTile({
    super.key,
    required this.consultation,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    return '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}/'
        '${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE3F2FD),
              child: Text(
                consultation.patientName.isNotEmpty
                    ? consultation.patientName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  color: _accentBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consultation.patientName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _navy,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Madre: ${consultation.motherName}',
                    style: const TextStyle(fontSize: 12, color: _mutedGrey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    consultation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: _mutedGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatDate(consultation.lastMessageDate),
                  style: const TextStyle(fontSize: 11, color: _mutedGrey),
                ),
                const SizedBox(height: 8),
                if (consultation.messageCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _accentBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${consultation.messageCount}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
