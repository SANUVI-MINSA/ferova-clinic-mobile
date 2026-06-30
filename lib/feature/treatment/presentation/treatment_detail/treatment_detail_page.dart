import 'package:ferova_clinic_flutter/core/di/dependency_injection.dart';
import 'package:ferova_clinic_flutter/feature/treatment/domain/repositories/treatment_repository.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/treatment_detail/treatment_detail_state.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/treatment_detail/treatment_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/model/treatment_detail.dart';
import 'action_buttons.dart';

class TreatmentDetailPage extends StatelessWidget {
  final String treatmentId;

  const TreatmentDetailPage({
    super.key,
    required this.treatmentId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TreatmentDetailViewModel(
        repository: getIt<TreatmentRepository>(),
        treatmentId: treatmentId,
      ),
      child: const _TreatmentDetailContent(),
    );
  }
}

class _TreatmentDetailContent extends StatelessWidget {
  const _TreatmentDetailContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TreatmentDetailViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detalle de Tratamiento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D6EA8),
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D6EA8)),
      )
          : state.errorMessage != null
          ? _buildErrorWidget(state.errorMessage!, viewModel)
          : state.treatment == null
          ? _buildEmptyWidget()
          : _buildContent(context, viewModel, state),
    );
  }

  Widget _buildErrorWidget(String error, TreatmentDetailViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar el detalle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.loadTreatmentDetail(),
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
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return const Center(
      child: Text(
        'No se encontró el tratamiento',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF6B7D8F),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      TreatmentDetailViewModel viewModel,
      TreatmentDetailState state,
      ) {
    final treatment = state.treatment!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Paciente
          _buildPatientInfo(treatment),
          const SizedBox(height: 16),

          // Plan de Dosis
          _buildDosePlan(treatment),
          const SizedBox(height: 16),

          // Cronología
          _buildTimeline(treatment),
          const SizedBox(height: 16),

          // Adherencia
          _buildAdherence(treatment),
          const SizedBox(height: 16),

          // Notas adicionales (si existen)
          if (treatment.completionObservation != null || treatment.abandonmentObservation != null)
            _buildNotes(treatment),

          if (treatment.completionObservation != null || treatment.abandonmentObservation != null)
            const SizedBox(height: 16),

          // Botones de acción
          ActionButtons(
            treatment: treatment,
            onComplete: (observation) async {
              try {
                await viewModel.completeTreatment(observation);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tratamiento completado exitosamente'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            onAbandon: (observation) async {
              try {
                await viewModel.abandonTreatment(observation);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tratamiento abandonado'),
                      backgroundColor: Color(0xFFC62828),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPatientInfo(TreatmentDetail treatment) {
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
          const Text(
            'Paciente',
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
              Text(
                treatment.patientName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A3A5C),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: treatment.statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  treatment.statusLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: treatment.statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDosePlan(TreatmentDetail treatment) {
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
          const Text(
            'Plan de Dosis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3A5C),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Suplemento', treatment.supplementName),
          const SizedBox(height: 8),
          _buildInfoRow('Cantidad', treatment.quantity),
          const SizedBox(height: 8),
          _buildInfoRow('Horario', treatment.dosingHours),
          const SizedBox(height: 8),
          _buildInfoRow('Duración', '${treatment.durationDays} días'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7D8F),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A3A5C),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(TreatmentDetail treatment) {
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
          const Text(
            'CRONOLOGÍA',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7D8F),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INICIO',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7D8F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      treatment.formattedStartDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3A5C),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FIN EST.',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7D8F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      treatment.formattedEndDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A3A5C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdherence(TreatmentDetail treatment) {
    final percentage = treatment.adherencePercentage;
    final isGood = percentage >= 80;

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
          const Text(
            'Adherencia',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7D8F),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Desempeño del paciente',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[200],
                  color: isGood ? const Color(0xFF2E7D32) : const Color(0xFFFFA726),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isGood ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confirmadas: ${treatment.totalConfirmed}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7D8F),
                ),
              ),
              Text(
                'Omitidas: ${treatment.totalOmitted}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7D8F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotes(TreatmentDetail treatment) {
    final observation = treatment.completionObservation ?? treatment.abandonmentObservation;
    if (observation == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
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
          Text(
            observation,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF5D4037),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}