import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../domain/model/treatment_summary.dart';

class TreatmentCard extends StatelessWidget {
  final TreatmentSummary treatment;
  final VoidCallback onTap;

  const TreatmentCard({
    super.key,
    required this.treatment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAbandoned = treatment.status == 'ABANDONED';
    final isCompleted = treatment.status == 'COMPLETED';
    final hasSupplement = treatment.supplementName.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isAbandoned
                ? Colors.grey[200]!
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar mejorado
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isAbandoned
                    ? LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[400]!],
                )
                    : LinearGradient(
                  colors: [
                    const Color(0xFF0D6EA8).withValues(alpha: 0.2),
                    const Color(0xFF0D6EA8).withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  _getInitials(treatment.patientName),
                  style: TextStyle(
                    color: isAbandoned
                        ? Colors.grey[600]
                        : const Color(0xFF0D6EA8),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Contenido principal
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila: Nombre + Estado
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          treatment.patientName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isAbandoned
                                ? Colors.grey[500]
                                : const Color(0xFF1A3A5C),
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusBadge(treatment.statusLabel, treatment.statusColor),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Info del suplemento o estado
                  if (!isAbandoned && !isCompleted && hasSupplement) ...[
                    _buildSupplementInfo(treatment.supplementName),
                  ] else if (isAbandoned) ...[
                    _buildAbandonedInfo(),
                  ] else if (isCompleted) ...[
                    _buildCompletedInfo(),
                  ] else ...[
                    _buildNoSupplementInfo(),
                  ],
                ],
              ),
            ),

            // Flecha de navegación
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF0D6EA8).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF0D6EA8),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupplementInfo(String supplementName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.medication_rounded,
              size: 14,
              color: Colors.grey[500],
            ),
            const SizedBox(width: 6),
            Text(
              'Suplemento',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          supplementName,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A5C),
            letterSpacing: -0.2,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildAbandonedInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 14,
            color: Colors.grey[500],
          ),
          const SizedBox(width: 6),
          Text(
            'Tratamiento abandonado',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 14,
            color: Colors.green[600],
          ),
          const SizedBox(width: 6),
          Text(
            'Tratamiento completado',
            style: TextStyle(
              fontSize: 12,
              color: Colors.green[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSupplementInfo() {
    return Row(
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 14,
          color: Colors.grey[400],
        ),
        const SizedBox(width: 6),
        Text(
          'Sin suplemento asignado',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
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