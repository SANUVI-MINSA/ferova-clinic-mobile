import 'package:flutter/material.dart';

const _navy = Color(0xFF1A3A5C);
const _accentBlue = Color(0xFF0D6EA8);
const _mutedGrey = Color(0xFF6B7D8F);

/// Shows a confirm/cancel dialog and returns `true` when the nurse confirms
/// closing the consultation, `false`/`null` otherwise.
Future<bool?> showCloseConsultationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Cerrar consulta',
        style: TextStyle(fontWeight: FontWeight.bold, color: _navy),
      ),
      content: const Text(
        '¿Estás segura de que querés cerrar esta consulta? '
        'No podrás enviar más mensajes después de cerrarla.',
        style: TextStyle(color: _mutedGrey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar', style: TextStyle(color: _mutedGrey)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}
