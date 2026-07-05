import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/hemoglobin_control_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/hemoglobin_control_tile.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/hemoglobin_control_view_model.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/new_hemoglobin_control_page.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_pdf_view_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

const _navy = Color(0xFF1A3A5C);
const _accentBlue = Color(0xFF0D6EA8);
const _mutedGrey = Color(0xFF6B7D8F);
const _borderColor = Color(0xFFE2E8F0);
const _anemiaRed = Color(0xFF940010);

const _labelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: _mutedGrey,
  letterSpacing: 0.5,
);

String _formatNumber(num value) {
  return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
}

class HemoglobinControlHistoryPage extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String medicalRecordId;

  const HemoglobinControlHistoryPage({
    super.key,
    required this.patientId,
    required this.patientName,
    required this.medicalRecordId,
  });

  @override
  State<HemoglobinControlHistoryPage> createState() =>
      _HemoglobinControlHistoryPageState();
}

class _HemoglobinControlHistoryPageState
    extends State<HemoglobinControlHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadControls());
  }

  void _loadControls() {
    context.read<HemoglobinControlViewModel>().getHemoglobinControls(
      widget.medicalRecordId,
    );
  }

  void _navigateToNewControl() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewHemoglobinControlPage(
          patientId: widget.patientId,
          patientName: widget.patientName,
          onControlCreated: _loadControls,
        ),
      ),
    );
  }

  Future<void> _onDescargar(
    BuildContext context,
    MedicalRecordPdfViewModel pdfViewModel,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    final bytes = await pdfViewModel.getHemoglobinReportPdf(
      widget.medicalRecordId,
    );

    if (!mounted) return;

    if (bytes == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo generar el PDF: '
            '${pdfViewModel.state.hemoglobinReportPdfErrorMessage}',
          ),
        ),
      );
      return;
    }

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'historial_hemoglobina_${widget.patientName}.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HemoglobinControlViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: _navy),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Historial de Controles',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _navy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: _buildBody(context, state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, HemoglobinControlState state) {
    if (state.isLoadingControls) {
      return const Center(
        child: CircularProgressIndicator(color: _accentBlue),
      );
    }

    if (state.controlsErrorMessage != null) {
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
                'Error: ${state.controlsErrorMessage}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadControls,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
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

    final hemoglobinControls = state.hemoglobinControls;
    if (hemoglobinControls == null) return const SizedBox.shrink();

    final controls = [...hemoglobinControls.controls]
      ..sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'PROMEDIO',
                value: '${_formatNumber(hemoglobinControls.averageHemoglobin)} g/dL',
                valueColor: _navy,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'EVOLUCIÓN',
                value: hemoglobinControls.evolution == null
                    ? '-'
                    : '${hemoglobinControls.evolution! > 0 ? '+' : ''}'
                          '${_formatNumber(hemoglobinControls.evolution!)} g/dL',
                valueColor: (hemoglobinControls.evolution ?? 0) < 0
                    ? _anemiaRed
                    : _accentBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Registros Recientes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _navy,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: controls.isEmpty
              ? Center(
                  child: Text(
                    'No hay controles registrados.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controls.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      HemoglobinControlTile(control: controls[index]),
                ),
        ),
        const SizedBox(height: 16),
        Builder(
          builder: (context) {
            final pdfViewModel = context.watch<MedicalRecordPdfViewModel>();
            final isDownloading =
                pdfViewModel.state.isDownloadingHemoglobinReportPdf;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isDownloading
                    ? null
                    : () => _onDescargar(context, pdfViewModel),
                icon: isDownloading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_rounded, size: 20),
                label: Text(
                  isDownloading ? 'Generando PDF...' : 'Descargar',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _navigateToNewControl,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'Nuevo Control',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

