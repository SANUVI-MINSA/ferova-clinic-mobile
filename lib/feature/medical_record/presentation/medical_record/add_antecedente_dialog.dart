import 'package:flutter/material.dart';

import '../../domain/model/value_objects/patient_history.dart';

class AddAntecedenteDialog extends StatefulWidget {
  final Function(PatientHistory) onConfirm;

  const AddAntecedenteDialog({super.key, required this.onConfirm});

  @override
  State<AddAntecedenteDialog> createState() => _AddAntecedenteDialogState();
}

class _AddAntecedenteDialogState extends State<AddAntecedenteDialog> {
  static const List<String> _tipos = [
    'Familiar',
    'Personal',
    'Perinatal',
    'Alimentario',
    'Alérgico',
  ];

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7D8F),
    letterSpacing: 0.5,
  );

  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool get _canSubmit =>
      _tipoController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _tipoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onConfirm(
      PatientHistory(
        type: _tipoController.text.trim(),
        description: _descriptionController.text.trim(),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFEDF0FB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: const Text(
                'Añadir Antecedente',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3A5C),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TIPO DE ANTECEDENTE', style: _labelStyle),
                  const SizedBox(height: 8),
                  DropdownMenu<String>(
                    controller: _tipoController,
                    expandedInsets: EdgeInsets.zero,
                    hintText: 'Seleccione tipo o escribe',
                    onSelected: (_) => setState(() {}),
                    inputDecorationTheme: InputDecorationTheme(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E7EF)),
                      ),
                    ),
                    dropdownMenuEntries: _tipos
                        .map(
                          (tipo) => DropdownMenuEntry(value: tipo, label: tipo),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('DESCRIPCIÓN', style: _labelStyle),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText:
                          'Describa el diagnóstico, fecha aproximada o detalles relevantes...',
                      hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E7EF)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE0E7EF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF4FC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF0D6EA8),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Esta información será visible para todo el equipo médico encargado del seguimiento de la anemia del paciente.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0D6EA8),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 33),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC62828),
                        side: const BorderSide(color: Color(0xFFC62828)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _canSubmit ? _submit : null,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Añadir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A3A5C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
