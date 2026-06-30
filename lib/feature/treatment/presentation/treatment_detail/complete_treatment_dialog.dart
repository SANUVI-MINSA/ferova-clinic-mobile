import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompleteTreatmentDialog extends StatefulWidget {
  final String patientName;
  final String supplementName;
  final int durationDays;
  final Function(String) onConfirm;

  const CompleteTreatmentDialog({
    super.key,
    required this.patientName,
    required this.supplementName,
    required this.durationDays,
    required this.onConfirm,
  });

  @override
  State<CompleteTreatmentDialog> createState() => _CompleteTreatmentDialogState();
}

class _CompleteTreatmentDialogState extends State<CompleteTreatmentDialog> {
  final TextEditingController _observationController = TextEditingController();
  bool _isConfirmed = false;

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Justificar Acción',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A3A5C),
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
                hintText: 'Describe los motivos de la finalización...',
                hintStyle: TextStyle(color: Color(0xFF9EAFC0)),
                contentPadding: EdgeInsets.all(12),
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: _isConfirmed,
                onChanged: (value) {
                  setState(() {
                    _isConfirmed = value ?? false;
                  });
                },
                activeColor: const Color(0xFF0D6EA8),
              ),
              const Expanded(
                child: Text(
                  'Confirmar',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A3A5C),
                  ),
                ),
              ),
            ],
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
          onPressed: (_isConfirmed && _observationController.text.isNotEmpty)
              ? () {
            widget.onConfirm(_observationController.text);
            Navigator.pop(context);
          }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D6EA8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Completar'),
        ),
      ],
    );
  }
}