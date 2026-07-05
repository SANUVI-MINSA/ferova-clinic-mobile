import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/hemoglobin_control.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/domain/model/entities/medical_record.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/hemoglobin_control/new_hemoglobin_control_page.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_pdf_view_model.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_state.dart';
import 'package:ferova_clinic_flutter/feature/medical_record/presentation/medical_record/medical_record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

const _navy = Color(0xFF1A3A5C);
const _accentBlue = Color(0xFF0D6EA8);
const _mutedGrey = Color(0xFF6B7D8F);
const _borderColor = Color(0xFFE2E8F0);
const _infoBoxColor = Color(0xFFEAF4FC);
const _anemiaRed = Color(0xFF940010);

const _labelStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: _mutedGrey,
  letterSpacing: 0.5,
);

const _monthsEs = [
  'Ene',
  'Feb',
  'Mar',
  'Abr',
  'May',
  'Jun',
  'Jul',
  'Ago',
  'Sep',
  'Oct',
  'Nov',
  'Dic',
];

String _formatDate(String isoDate) {
  final date = DateTime.tryParse(isoDate)?.toLocal();
  if (date == null) return '-';
  return '${date.day} ${_monthsEs[date.month - 1]}, ${date.year}';
}

String _formatNumber(num value) {
  return value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

const _maxPatientNameLength = 15;

String _truncateName(String name) {
  if (name.length <= _maxPatientNameLength) return name;
  return '${name.substring(0, _maxPatientNameLength)}...';
}

String _translateGender(String gender) {
  switch (gender.trim().toLowerCase()) {
    case 'male':
    case 'm':
      return 'Masculino';
    case 'female':
    case 'f':
      return 'Femenino';
    default:
      return gender;
  }
}

class MedicalRecordSummaryPage extends StatefulWidget {
  final String patientId;

  const MedicalRecordSummaryPage({super.key, required this.patientId});

  @override
  State<MedicalRecordSummaryPage> createState() =>
      _MedicalRecordSummaryPageState();
}

class _MedicalRecordSummaryPageState extends State<MedicalRecordSummaryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicalRecordViewModel>().getMedicalRecord(
        widget.patientId,
      );
    });
  }

  HemoglobinControl? _latestControl(List<HemoglobinControl> controls) {
    if (controls.isEmpty) return null;
    final sorted = [...controls]
      ..sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));
    return sorted.first;
  }

  void _onRealizarPrimerControl(MedicalRecord record) {
    final viewModel = context.read<MedicalRecordViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewHemoglobinControlPage(
          patientId: record.patientId,
          patientName: record.patientName,
          onControlCreated: () => viewModel.getMedicalRecord(record.patientId),
        ),
      ),
    );
  }

  void _onVerHistorial() {
    // TODO: Navegar al historial de controles de hemoglobina
  }

  Future<void> _onDescargarPdf(BuildContext context, MedicalRecord record) async {
    final pdfViewModel = context.read<MedicalRecordPdfViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final bytes = await pdfViewModel.getMedicalRecordPDF(record.id);

    if (!mounted) return;

    if (bytes == null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo generar el PDF: ${pdfViewModel.state.recordPdfErrorMessage}',
          ),
        ),
      );
      return;
    }

    await Printing.sharePdf(
      bytes: bytes,
      filename: 'historial_medico_${record.patientName}.pdf',
    );
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
                icon: const Icon(Icons.arrow_back_rounded, color: _navy),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 12),
              Expanded(child: _buildBody(context, state, viewModel)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MedicalRecordState state,
    MedicalRecordViewModel viewModel,
  ) {
    if (state.isLoadingRecord) {
      return const Center(
        child: CircularProgressIndicator(color: _accentBlue),
      );
    }

    if (state.recordErrorMessage != null) {
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
                'Error: ${state.recordErrorMessage}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => viewModel.getMedicalRecord(widget.patientId),
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

    final record = state.medicalRecord;
    if (record == null) return const SizedBox.shrink();

    final latestControl = _latestControl(record.controls);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            children: [
              const TextSpan(text: 'Paciente ', style: TextStyle(color: _accentBlue)),
              TextSpan(
                text: _truncateName(record.patientName),
                style: const TextStyle(color: _navy),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_today_rounded,
                        label: 'FECHA',
                        value: _formatDate(record.lastUpdated),
                        caption: 'Último registro',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.wc_rounded,
                        label: 'SEXO',
                        value: _translateGender(record.gender),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.monitor_weight_outlined,
                        label: 'PESO',
                        value: '${_formatNumber(record.weight)} kg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.straighten_rounded,
                        label: 'ALTURA',
                        value: '${record.height} cm',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _HemoglobinCard(
                  latestControl: latestControl,
                  onRealizarPrimerControl: () => _onRealizarPrimerControl(record),
                  onVerHistorial: _onVerHistorial,
                ),
                const SizedBox(height: 20),
                _InfoCard(
                  icon: Icons.medical_services_rounded,
                  title: 'Motivo de Consulta',
                  child: Text(
                    record.consultationReason,
                    style: const TextStyle(
                      fontSize: 14,
                      color: _navy,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _InfoCard(
                  icon: Icons.visibility_rounded,
                  title: 'Observaciones',
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: _accentBlue, width: 3),
                      ),
                    ),
                    child: Text(
                      '"${record.observations}"',
                      style: const TextStyle(
                        fontSize: 14,
                        color: _navy,
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('ANTECEDENTES', style: _labelStyle),
                const SizedBox(height: 10),
                if (record.patientHistories.isEmpty)
                  Text(
                    'No hay antecedentes registrados.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: record.patientHistories
                        .map(
                          (history) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _borderColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${history.type}: ${history.description}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: _mutedGrey,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 20),
                const Text('SÍNTOMAS ACTUALES', style: _labelStyle),
                const SizedBox(height: 10),
                if (record.symptoms.isEmpty)
                  Text(
                    'No hay síntomas registrados.',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: record.symptoms
                        .map(
                          (symptom) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: _accentBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              symptom,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
        Builder(
          builder: (context) {
            final isDownloading = context
                .watch<MedicalRecordPdfViewModel>()
                .state
                .isDownloadingRecordPdf;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isDownloading
                    ? null
                    : () => _onDescargarPdf(context, record),
                icon: isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download_rounded, size: 22),
                label: Text(
                  isDownloading ? 'Generando PDF...' : 'Descargar PDF',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? caption;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.caption,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: _accentBlue),
              Text(label, style: _labelStyle),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _navy,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption ?? '',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class _HemoglobinCard extends StatelessWidget {
  final HemoglobinControl? latestControl;
  final VoidCallback onRealizarPrimerControl;
  final VoidCallback onVerHistorial;

  const _HemoglobinCard({
    required this.latestControl,
    required this.onRealizarPrimerControl,
    required this.onVerHistorial,
  });

  @override
  Widget build(BuildContext context) {
    final control = latestControl;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.bloodtype_rounded,
                size: 20,
                color: control == null ? _mutedGrey : _anemiaRed,
              ),
              const Text('HEMOGLOBINA', style: _labelStyle),
            ],
          ),
          const SizedBox(height: 14),
          if (control == null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sin registros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pendiente de control',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: onRealizarPrimerControl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Añadir Control',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${_formatNumber(control.hemoglobinLevel)} g/dL',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
                TextButton.icon(
                  onPressed: onVerHistorial,
                  icon: const Icon(Icons.history_rounded, size: 16),
                  label: const Text(
                    'VER HISTORIAL',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(foregroundColor: _accentBlue),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: _infoBoxColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: _navy),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}
