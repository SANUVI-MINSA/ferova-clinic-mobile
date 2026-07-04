import 'package:flutter/material.dart';

class AddSymptomDialog extends StatefulWidget {
  final Function(String) onConfirm;

  const AddSymptomDialog({super.key, required this.onConfirm});

  @override
  State<AddSymptomDialog> createState() => _AddSymptomDialogState();
}

class _AddSymptomDialogState extends State<AddSymptomDialog> {
  static const List<String> _sintomasFrecuentes = [
    'Somnolencia',
    'Cefalea',
    'Disnea',
    'Palpitaciones',
  ];

  static const TextStyle _labelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6B7D8F),
    letterSpacing: 0.5,
  );

  final TextEditingController _searchController = TextEditingController();

  bool get _canSubmit => _searchController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectSintoma(String sintoma) {
    setState(() => _searchController.text = sintoma);
  }

  void _submit() {
    widget.onConfirm(_searchController.text.trim());
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Añadir Síntoma',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A3A5C),
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BUSCAR O SELECCIONAR SÍNTOMA',
                    style: _labelStyle,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Ej: Palidez, Taquicardia...',
                      hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF9EAFC0),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFEDF0FB),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('SÍNTOMAS FRECUENTES', style: _labelStyle),
                  const SizedBox(height: 8),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.6,
                    children: _sintomasFrecuentes.map((sintoma) {
                      final bool isSelected = _searchController.text == sintoma;
                      return OutlinedButton(
                        onPressed: () => _selectSintoma(sintoma),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isSelected
                              ? const Color(0xFFE8F3FB)
                              : Colors.white,
                          foregroundColor: const Color(0xFF1A3A5C),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF0D6EA8)
                                : const Color(0xFFE0E7EF),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(sintoma, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
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
                      icon: const Icon(Icons.check_rounded, size: 18),
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
