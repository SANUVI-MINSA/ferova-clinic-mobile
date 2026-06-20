import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_state.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/confirmed_nurse_assign_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NurseSelectionPage extends StatefulWidget {
  final AdminFacility facility;

  const NurseSelectionPage({super.key, required this.facility});

  @override
  State<NurseSelectionPage> createState() => _NurseSelectionPageState();
}

class _NurseSelectionPageState extends State<NurseSelectionPage> {
  Nurse? _selectedNurse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminFacilityViewModel>().getAvailableNurses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AdminFacilityViewModel>();
    final AdminFacilityState state = viewModel.state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF003178)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Asignar a ${widget.facility.name}',
          style: const TextStyle(
            color: Color(0xFF003178),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enfermeros Disponibles',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: state.isLoadingAvailableNurses
                  ? const Center(
                key: ValueKey('loading'),
                child: CircularProgressIndicator(
                  color: Color(0xFF003178),
                ),
              )
                  : state.errorMessage != null
                  ? Center(
                key: const ValueKey('error'),
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              )
                  : state.availableNurses.isEmpty
                  ? Center(
                key: const ValueKey('empty'),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay enfermeros disponibles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Todos los enfermeros ya están asignados a otras postas',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                key: const ValueKey('content'),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: state.availableNurses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final Nurse nurse = state.availableNurses[index];
                  final bool isSelected = _selectedNurse?.id == nurse.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNurse = (_selectedNurse?.id == nurse.id)
                            ? null
                            : nurse;
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2D60E8)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2D60E8)
                              : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        nurse.fullName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (_selectedNurse != null)
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF003178),
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Solo puedes asignar un enfermero para esta posta y para el resto de postas.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF003178),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<AdminFacilityViewModel>(
                      builder: (context, vm, _) {
                        final bool isLoading = vm.state.isLoadingNurseAssignment;
                        return ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
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
                                      Icons.person_add_outlined,
                                      color: Color(0xFF003178),
                                      size: 40,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      '¿Confirmar asignación?',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A1A2E),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Se asignará a ${_selectedNurse!.fullName} como enfermero/a de ${widget.facility.name}.',
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
                                      child: Consumer<AdminFacilityViewModel>(
                                        builder: (context, innerVm, _) {
                                          final bool isAssigning =
                                              innerVm.state.isLoadingNurseAssignment;
                                          return ElevatedButton(
                                            onPressed: isAssigning
                                                ? null
                                                : () async {
                                              // ✅ Obtener el viewModel actualizado
                                              final viewModel = context
                                                  .read<AdminFacilityViewModel>();

                                              // ✅ Llamar a assignNurse
                                              await viewModel.assignNurse(
                                                widget.facility.id,
                                                _selectedNurse!.id,
                                              );

                                              if (!context.mounted) return;

                                              // ✅ Cerrar el diálogo
                                              Navigator.pop(ctx);

                                              // ✅ Esperar a que el estado se actualice
                                              await Future.delayed(
                                                const Duration(milliseconds: 200),
                                              );

                                              if (!context.mounted) return;

                                              // ✅ Obtener el estado actualizado
                                              final updatedViewModel =
                                              context.read<AdminFacilityViewModel>();
                                              final updatedState =
                                                  updatedViewModel.state;

                                              // ✅ Verificar si la asignación fue exitosa
                                              if (updatedState.isNurseAssigned) {
                                                // ✅ Éxito - navegar a la página de confirmación
                                                if (!context.mounted) return;

                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ConfirmedNurseAssignPage(
                                                          nurse:
                                                          _selectedNurse!,
                                                          adminFacility:
                                                          widget.facility,
                                                          message: updatedState
                                                              .assignmentMessage ??
                                                              'Enfermero asignado exitosamente',
                                                        ),
                                                  ),
                                                );
                                              } else {
                                                // ❌ Error - mostrar mensaje
                                                if (!context.mounted) return;

                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      updatedState
                                                          .errorMessage ??
                                                          'Error al asignar enfermero',
                                                    ),
                                                    backgroundColor:
                                                    Colors.redAccent,
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(
                                                0xFF003178,
                                              ),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                  10,
                                                ),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: isAssigning
                                                ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child:
                                              CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                                : const Text(
                                              'Confirmar',
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
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xFF6B7D8F),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003178),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          icon: isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Icon(Icons.person_add_outlined, size: 20),
                          label: Text(
                            isLoading ? 'Asignando...' : 'Confirmar Asignación',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
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