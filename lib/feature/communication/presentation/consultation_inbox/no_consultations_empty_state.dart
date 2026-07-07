import 'package:flutter/material.dart';

const _navy = Color(0xFF1A3A5C);
const _mutedGrey = Color(0xFF6B7D8F);
const _accentBlue = Color(0xFF0D6EA8);

class NoConsultationsEmptyState extends StatelessWidget {
  final String? message;
  final String? detail;

  const NoConsultationsEmptyState({super.key, this.message, this.detail});

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
                Icons.chat_bubble_outline_rounded,
                color: _accentBlue,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message ?? 'No tienes consultas activas',
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
          ],
        ),
      ),
    );
  }
}
