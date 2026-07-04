import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/value_objects/patient_history.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/add_antecedente_dialog.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/add_symptom_dialog.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _labelStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Color(0xFF6B7D8F),
  letterSpacing: 0.5,
);

const _fieldBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(color: Color(0xFFE0E7EF)),
);

class RegisterMedicalRecordPage extends StatefulWidget {
  final String patientId;

  const RegisterMedicalRecordPage({super.key, required this.patientId});

  @override
  State<RegisterMedicalRecordPage> createState() =>
      _RegisterMedicalRecordPageState();
}

class _RegisterMedicalRecordPageState extends State<RegisterMedicalRecordPage> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _consultationReasonController =
      TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  final List<PatientHistory> _patientHistories = [];
  final List<String> _symptoms = [];

  bool get _canSubmit =>
      _weightController.text.trim().isNotEmpty &&
      _heightController.text.trim().isNotEmpty &&
      _consultationReasonController.text.trim().isNotEmpty &&
      _observationsController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _consultationReasonController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _addAntecedente() {
    showDialog(
      context: context,
      builder: (_) => AddAntecedenteDialog(
        onConfirm: (history) => setState(() => _patientHistories.add(history)),
      ),
    );
  }

  void _addSintoma() {
    showDialog(
      context: context,
      builder: (_) => AddSymptomDialog(
        onConfirm: (sintoma) => setState(() => _symptoms.add(sintoma)),
      ),
    );
  }

  Future<void> _submit() async {
    final viewModel = context.read<MedicalRecordViewModel>();
    await viewModel.postMedicalRecord(
      patientId: widget.patientId,
      weight: double.tryParse(_weightController.text.trim()) ?? 0,
      height: int.tryParse(_heightController.text.trim()) ?? 0,
      consultationReason: _consultationReasonController.text.trim(),
      observations: _observationsController.text.trim(),
      patientHistories: _patientHistories,
      symptoms: _symptoms,
    );

    if (!mounted) return;

    final error = viewModel.state.saveErrorMessage;
    if (error == null) {
      viewModel.markPatientHasRecord(widget.patientId);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MedicalRecordViewModel>();
    final MedicalRecordState state = viewModel.state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF1A3A5C),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 12),
              const Text(
                'Registrar Historial Médico',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A5C),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Complete los datos de la consulta actual para el seguimiento del paciente.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
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
                                'Los niveles de hemoglobina se registrarán y monitorearán a través de controles diagnósticos posteriores para asegurar la precisión del tratamiento.',
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
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('PESO (KG)', style: _labelStyle),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _weightController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(
                                    hintText: '0.0',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF9EAFC0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    border: _fieldBorder,
                                    enabledBorder: _fieldBorder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('ALTURA (CM)', style: _labelStyle),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _heightController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                  decoration: const InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF9EAFC0),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    border: _fieldBorder,
                                    enabledBorder: _fieldBorder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text('MOTIVO DE CONSULTA', style: _labelStyle),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _consultationReasonController,
                        minLines: 4,
                        maxLines: 4,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Describa la razón de la visita...',
                          hintStyle: TextStyle(color: Color(0xFF9EAFC0)),
                          contentPadding: EdgeInsets.all(12),
                          border: _fieldBorder,
                          enabledBorder: _fieldBorder,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('OBSERVACIONES', style: _labelStyle),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _observationsController,
                        minLines: 4,
                        maxLines: 4,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Notas adicionales del profesional...',
                          hintStyle: TextStyle(color: Color(0xFF9EAFC0)),
                          contentPadding: EdgeInsets.all(12),
                          border: _fieldBorder,
                          enabledBorder: _fieldBorder,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('ANTECEDENTES', style: _labelStyle),
                          TextButton.icon(
                            onPressed: _addAntecedente,
                            icon: const Icon(
                              Icons.add_circle_outline_rounded,
                              size: 18,
                            ),
                            label: const Text('Añadir'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0D6EA8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_patientHistories.isEmpty)
                        Text(
                          'Aún no se han registrado antecedentes.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        )
                      else
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 160),
                          child: Scrollbar(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _patientHistories.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final history = _patientHistories[index];
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF4FC),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFF1A3A5C),
                                            ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${history.type.toUpperCase()}: ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: history.description,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => setState(
                                          () =>
                                              _patientHistories.removeAt(index),
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          size: 18,
                                          color: Color(0xFF6B7D8F),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('SÍNTOMAS REPORTADOS', style: _labelStyle),
                          TextButton.icon(
                            onPressed: _addSintoma,
                            icon: const Icon(
                              Icons.add_circle_outline_rounded,
                              size: 18,
                            ),
                            label: const Text('Añadir'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF0D6EA8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_symptoms.isEmpty)
                        Text(
                          'Aún no se han reportado síntomas.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        )
                      else
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 120),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(_symptoms.length, (
                                  index,
                                ) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF4FC),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _symptoms[index],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1A3A5C),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        GestureDetector(
                                          onTap: () => setState(
                                            () => _symptoms.removeAt(index),
                                          ),
                                          child: const Icon(
                                            Icons.close_rounded,
                                            size: 16,
                                            color: Color(0xFF6B7D8F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isSavingRecord || !_canSubmit
                      ? null
                      : _submit,
                  icon: state.isSavingRecord
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded, size: 18),
                  label: Text(
                    state.isSavingRecord ? 'Guardando...' : 'Guardar Historial',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A3A5C),
                    foregroundColor: Colors.white,
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
