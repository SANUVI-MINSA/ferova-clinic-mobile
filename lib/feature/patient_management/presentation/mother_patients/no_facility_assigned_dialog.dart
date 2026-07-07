import 'package:flutter/material.dart';

class NoFacilityAssignedDialog extends StatelessWidget {
  const NoFacilityAssignedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: Color(0xFFD32F2F),
        size: 40,
      ),
      title: const Text(
        'Sin posta asignada',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF1A3A5C),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        'No tienes una posta asignada por el administrador. '
        'Comunícate con tu administrador para poder asignar pacientes.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Color(0xFF6B7D8F)),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D6EA8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Entendido'),
        ),
      ],
    );
  }
}
