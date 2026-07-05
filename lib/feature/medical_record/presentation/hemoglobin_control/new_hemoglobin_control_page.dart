import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/hemoglobin_control_success_page.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/hemoglobin_control_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

const _navy = Color(0xFF1A3A5C);
const _accentBlue = Color(0xFF0D6EA8);
const _mutedGrey = Color(0xFF6B7D8F);
const _borderColor = Color(0xFFE2E8F0);
const _infoBoxColor = Color(0xFFEAF4FC);
const _iconChipColor = Color(0xFFE8F3FB);
const _headerStripColor = Color(0xFFF8FAFC);
const _anemiaRed = Color(0xFF940010);

const _labelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: _mutedGrey,
  letterSpacing: 0.5,
);

const _fieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(color: Color(0xFFE0E7EF)),
);

class NewHemoglobinControlPage extends StatefulWidget {
  final String patientId;
  final String patientName;

  /// Called after the success screen is dismissed, so the screen that
  /// pushed this one (patient list or medical record summary) can refresh
  /// itself if needed.
  final VoidCallback? onControlCreated;

  const NewHemoglobinControlPage({
    super.key,
    required this.patientId,
    required this.patientName,
    this.onControlCreated,
  });

  @override
  State<NewHemoglobinControlPage> createState() =>
      _NewHemoglobinControlPageState();
}

class _NewHemoglobinControlPageState extends State<NewHemoglobinControlPage> {
  final TextEditingController _hemoglobinController = TextEditingController();
  String? _validationError;

  @override
  void dispose() {
    _hemoglobinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    final rawValue = _hemoglobinController.text.trim().replaceAll(',', '.');
    final hemoglobinLevel = double.tryParse(rawValue);

    if (hemoglobinLevel == null || hemoglobinLevel <= 0 || hemoglobinLevel > 30) {
      setState(() {
        _validationError = 'Ingrese un valor de hemoglobina entre 0 y 30 g/dL';
      });
      return;
    }
    setState(() => _validationError = null);

    final viewModel = context.read<HemoglobinControlViewModel>();
    final success = await viewModel.createHemoglobinLevel(
      widget.patientId,
      hemoglobinLevel,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HemoglobinControlSuccessPage(
            patientName: widget.patientName,
            hemoglobinLevel: hemoglobinLevel,
            date: DateTime.now().toIso8601String(),
            onReturn: widget.onControlCreated,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${viewModel.state.createErrorMessage}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HemoglobinControlViewModel>();
    final isCreatingLevel = viewModel.state.isCreatingLevel;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: _navy),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 12),
              const Text(
                'Nuevo Control',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 20),
              _SelectedPatientCard(patientName: widget.patientName),
              const SizedBox(height: 16),
              _HemoglobinInputCard(
                controller: _hemoglobinController,
                errorText: _validationError,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isCreatingLevel ? null : _submit,
                  icon: isCreatingLevel
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add_rounded, size: 20),
                  label: Text(
                    isCreatingLevel ? 'Guardando...' : 'Añadir Control',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentBlue,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _accentBlue.withValues(
                      alpha: 0.6,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedPatientCard extends StatelessWidget {
  final String patientName;

  const _SelectedPatientCard({required this.patientName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: _headerStripColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: _borderColor)),
            ),
            child: const Text('PACIENTE SELECCIONADO', style: _labelStyle),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _iconChipColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: _accentBlue,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HemoglobinInputCard extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;

  const _HemoglobinInputCard({required this.controller, this.errorText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HEMOGLOBINA (G/DL)', style: _labelStyle),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*')),
            ],
            style: const TextStyle(
              fontSize: 16,
              color: _navy,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: '10.2',
              hintStyle: const TextStyle(
                color: Color(0xFF9EAFC0),
                fontWeight: FontWeight.normal,
              ),
              suffixText: 'g/dL',
              suffixStyle: const TextStyle(
                color: _mutedGrey,
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: const Color(0xFFF7F9FB),
              border: _fieldBorder,
              enabledBorder: _fieldBorder,
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: _accentBlue),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              errorText!,
              style: const TextStyle(fontSize: 12, color: _anemiaRed),
            ),
          ],
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _infoBoxColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded, color: _accentBlue, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Este registro se integrará inmediatamente a la curva de '
                    'evolución del paciente. Asegúrese de que el valor sea '
                    'preciso antes de guardar.',
                    style: TextStyle(
                      fontSize: 12,
                      color: _accentBlue,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
