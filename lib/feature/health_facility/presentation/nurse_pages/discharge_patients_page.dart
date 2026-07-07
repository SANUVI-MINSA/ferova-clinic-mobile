import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/discharge_patient.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/discharge_state.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/nurse_pages/discharge_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../patient_management/presentation/mother_search/mother_search_page.dart';

class DischargePatientsPage extends StatefulWidget {
  final VoidCallback? onGoToPatients;
  const DischargePatientsPage({super.key, this.onGoToPatients});

  @override
  State<DischargePatientsPage> createState() => _DischargePatientsPageState();
}

class _DischargePatientsPageState extends State<DischargePatientsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    // ✅ FORZAR RECARGA AL ENTRAR A LA PÁGINA
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<DischargeViewModel>();
      debugPrint('🔄 Recargando pacientes al entrar a la página');
      viewModel.refresh(); // ← Usar el nuevo método refresh()
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _initials(String fullName) {
    if (fullName.trim().isEmpty) return '?';
    final words = fullName.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return fullName.substring(0, 2).toUpperCase();
  }

  void _onSearchChanged(String value, DischargeViewModel viewModel) {
    setState(() => _searchTerm = value);
    viewModel.getPatients(searchTerm: value.isEmpty ? null : value, silent: true);
  }

  void _navigateToAssignPatient() {
    if (widget.onGoToPatients != null) {
      widget.onGoToPatients!();
      Navigator.pop(context);
    }
  }

  void _confirmDischarge(BuildContext context, DischargePatient patient) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.person_remove_outlined,
              color: Color(0xFF2563EB),
              size: 40,
            ),
            const SizedBox(height: 12),
            const Text(
              '¿Confirmar alta?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Se dará de alta a ${patient.fullName}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7D8F),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Consumer<DischargeViewModel>(
                builder: (context, vm, _) {
                  final bool isDischarging = vm.state.isDischarging;
                  return ElevatedButton(
                    onPressed: isDischarging
                        ? null
                        : () async {
                      await context
                          .read<DischargeViewModel>()
                          .dischargePatient(patient.id);
                      if (!context.mounted) return;
                      Navigator.pop(ctx);
                      if (context.read<DischargeViewModel>().state.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              context.read<DischargeViewModel>().state.errorMessage!,
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: isDischarging
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Confirmar alta',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 15, color: Color(0xFF6B7D8F)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      key: const ValueKey('empty'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'No hay pacientes para dar de alta',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Actualmente no tienes pacientes asignados en tu cartera activa que puedan ser procesados para el alta médica.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _navigateToAssignPatient,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Asignar un Paciente',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF2563EB),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REVISIÓN DE CARTERA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D4ED8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF374151),
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text:
                              'Si crees que esto es un error, por favor contacta al administrador de piso o verifica tus ',
                            ),
                            TextSpan(
                              text: 'pacientes en tratamiento',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchEmptyState() {
    return Center(
      key: const ValueKey('search_empty'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No se encontraron resultados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No hay pacientes elegibles para alta que coincidan con "$_searchTerm".',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<DischargePatient> patients) {
    return ListView.separated(
      key: const ValueKey('content'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: patients.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final patient = patients[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFEFF6FF),
                child: Text(
                  _initials(patient.fullName),
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  patient.fullName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _confirmDischarge(context, patient),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Dar de alta',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DischargeViewModel>();
    final DischargeState state = viewModel.state;
    final bool hasSearch = _searchTerm.isNotEmpty;

    // ✅ LOG PARA DEPURAR
    debugPrint('🔍 Estado: isLoading=${state.isLoading}, pacientes=${state.patients.length}, error=${state.errorMessage}');

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: const Color(0xFF2563EB),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dar de Alta',
          style: TextStyle(
            color: Color(0xFF2563EB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _onSearchChanged(value, viewModel),
              decoration: InputDecoration(
                hintText: 'Buscar paciente por nombre o apellido',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: const Color(0xFF2563EB),
              onRefresh: () => viewModel.refresh(), // ✅ Usar refresh()
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: state.isLoading
                    ? const Center(
                  key: ValueKey('loading'),
                  child: CircularProgressIndicator(
                    color: Color(0xFF2563EB),
                  ),
                )
                    : state.errorMessage != null
                    ? ListView(
                  key: const ValueKey('error'),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red.shade400),
                          const SizedBox(height: 12),
                          Text(
                            state.errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                    : state.patients.isEmpty && !hasSearch
                    ? _buildEmptyState()
                    : state.patients.isEmpty && hasSearch
                    ? _buildSearchEmptyState()
                    : _buildList(state.patients),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
