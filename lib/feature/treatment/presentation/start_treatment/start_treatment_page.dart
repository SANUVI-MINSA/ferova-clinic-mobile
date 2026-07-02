import 'package:ferova_clinic_flutter/feature/treatment/presentation/start_treatment/start_treatment_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/repositories/treatment_repository.dart';
import '../treatment_success/treatment_success_page.dart';
import '../widgets/treatment_error_dialog.dart';

class StartTreatmentPage extends StatefulWidget {
  final String patientId;
  final String patientName;

  const StartTreatmentPage({
    super.key,
    required this.patientId,
    required this.patientName,
  });

  @override
  State<StartTreatmentPage> createState() => _StartTreatmentPageState();
}

class _StartTreatmentPageState extends State<StartTreatmentPage> {
  late StartTreatmentViewModel viewModel;
  late TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    viewModel = StartTreatmentViewModel(
      repository: getIt<TreatmentRepository>(),
      patientId: widget.patientId,
      patientName: widget.patientName,
    );
    _durationController = TextEditingController(
      text: viewModel.state.durationDays.toString(),
    );
  }

  @override
  void dispose() {
    _durationController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.patientName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D6EA8),
        elevation: 0,
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          // Sincronizar el controlador con el estado actual
          if (_durationController.text != viewModel.state.durationDays.toString()) {
            _durationController.text = viewModel.state.durationDays.toString();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Configuración del Tratamiento',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A5C),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTreatmentForm(),
                const SizedBox(height: 16),
                _buildDosingNote(),
                const SizedBox(height: 16),
                _buildWarningNote(),
                const SizedBox(height: 24),
                _buildActivateButton(),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTreatmentForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuración del Suplemento',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7D8F),
            ),
          ),
          const SizedBox(height: 12),

          _buildConfigField(
            label: 'SUPLEMENTO DE HIERRO',
            value: viewModel.state.supplementName,
            onChanged: viewModel.updateSupplementName,
          ),
          const Divider(height: 24),

          _buildConfigField(
            label: 'CANTIDAD POR DOSIS',
            value: viewModel.state.quantity,
            onChanged: viewModel.updateQuantity,
          ),
          const Divider(height: 24),

          _buildConfigField(
            label: 'HORA DE DOSIS',
            value: viewModel.state.dosingHours,
            onChanged: viewModel.updateDosingHours,
          ),
          const Divider(height: 24),

          // ✅ NUEVO: Campo de duración con input manual
          _buildDurationField(),

          const SizedBox(height: 8),
          Text(
            'Finaliza aproximadamente el: ${viewModel.state.endDate ?? ''}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7D8F),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigField({
    required String label,
    required String value,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7D8F),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E7EF)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            initialValue: value,
            onChanged: onChanged,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A3A5C),
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  // ✅ CAMPO DE DURACIÓN CON INPUT MANUAL
  Widget _buildDurationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DURACIÓN DEL TRATAMIENTO',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B7D8F),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            // Botón -
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E7EF)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.remove, size: 20),
                onPressed: () {
                  final current = viewModel.state.durationDays;
                  if (current > 1) {
                    viewModel.updateDurationDays(current - 1);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),

            // ✅ Input manual
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E7EF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: _durationController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A5C),
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    border: InputBorder.none,
                    isDense: true,
                    suffixText: 'días',
                    suffixStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7D8F),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) return;
                    final newValue = int.tryParse(value);
                    if (newValue != null && newValue >= 1 && newValue <= 365) {
                      viewModel.updateDurationDays(newValue);
                    }
                  },
                  onFieldSubmitted: (value) {
                    // Validar cuando el usuario presiona Enter
                    if (value.isEmpty) {
                      _durationController.text = viewModel.state.durationDays.toString();
                      return;
                    }
                    final newValue = int.tryParse(value);
                    if (newValue == null || newValue < 1) {
                      _durationController.text = '1';
                      viewModel.updateDurationDays(1);
                    } else if (newValue > 365) {
                      _durationController.text = '365';
                      viewModel.updateDurationDays(365);
                    } else {
                      viewModel.updateDurationDays(newValue);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Botón +
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE0E7EF)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: () {
                  final current = viewModel.state.durationDays;
                  if (current < 365) {
                    viewModel.updateDurationDays(current + 1);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDosingNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFF57F17),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: const Text(
              'La dosis recomendada para un peso de 12.5kg es de 1.5ml a 2.5ml. '
                  'Verifique la tolerancia del paciente en los primeros 3 días.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF5D4037),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_rounded,
            color: Color(0xFFD32F2F),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: const Text(
              'Asegúrese de que el paciente no consuma lácteos 2 horas antes o después de la dosis.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFB71C1C),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivateButton() {
    final state = viewModel.state;

    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D6EA8)),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _onActivatePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D6EA8),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'ACTIVAR TRATAMIENTO',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Esta acción notificará al cuidador del paciente automáticamente.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7D8F),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _onActivatePressed() async {
    try {
      final response = await viewModel.startTreatment();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TreatmentSuccessPage(
              patientName: widget.patientName,
              treatment: response.treatment,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = viewModel.state.errorMessage ?? 'Error al iniciar el tratamiento';
        showDialog(
          context: context,
          builder: (context) => TreatmentErrorDialog(
            errorMessage: errorMessage,
            onRetry: () {
              viewModel.clearError();
              _onActivatePressed();
            },
          ),
        );
      }
    }
  }
}