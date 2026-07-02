import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbandonTreatmentDialog extends StatefulWidget {
  final String patientName;
  final Function(String) onConfirm;

  const AbandonTreatmentDialog({
    super.key,
    required this.patientName,
    required this.onConfirm,
  });

  @override
  State<AbandonTreatmentDialog> createState() => _AbandonTreatmentDialogState();
}

class _AbandonTreatmentDialogState extends State<AbandonTreatmentDialog> {
  final TextEditingController _observationController = TextEditingController();

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Justificar Abandono',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFFC62828),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOTAS ADICIONALES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7D8F),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E7EF)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _observationController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Describe los motivos del abandono...',
                hintStyle: TextStyle(color: Color(0xFF9EAFC0)),
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFCDD2)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_rounded,
                  color: Color(0xFFC62828),
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    '⚠️ Confirmar Abandono',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFC62828),
                    ),
                  ),
                ),
              ],
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
          onPressed: _observationController.text.isNotEmpty
              ? () {
            widget.onConfirm(_observationController.text);
            Navigator.pop(context);
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC62828),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Confirmar Abandono'),
        ),
      ],
    );
  }
}