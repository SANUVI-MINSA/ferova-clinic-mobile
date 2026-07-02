import 'package:flutter/material.dart';

class TreatmentErrorDialog extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const TreatmentErrorDialog({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'No se pudo iniciar el tratamiento',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD32F2F),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFD32F2F),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4A5A6A),
              height: 1.4,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Color(0xFF6B7D8F)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onRetry();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D6EA8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Reintentar'),
        ),
      ],
    );
  }
}