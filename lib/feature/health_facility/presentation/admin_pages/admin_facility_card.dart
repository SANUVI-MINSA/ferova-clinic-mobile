import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/nurse_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminFacilityCard extends StatelessWidget {
  final AdminFacility facility;

  const AdminFacilityCard({super.key, required this.facility});

  @override
  Widget build(BuildContext context) {
    return Selector<AdminFacilityViewModel, (bool, bool)>(
      selector: (_, vm) =>
          (vm.state.isLoadingNurseAvailability, vm.state.canRegisterFacilty),
      builder: (context, data, child) {
        final (isLoadingNurseAvailability, canRegisterFacilty) = data;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                facility.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Color(0xFF6B7D8F),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      facility.address,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7D8F),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (facility.hasNurseAssigned)
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
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF003178),
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal asignado',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7D8F),
                            ),
                          ),
                          Text(
                            facility.assignedNurseName ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFFED7AA)),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF59E0B),
                        size: 18,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sin enfermero/a asignado aún',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFF59E0B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isLoadingNurseAvailability
                        ? null
                        : () async {
                            final viewModel = context
                                .read<AdminFacilityViewModel>();
                            await viewModel.canRegisterFacility();

                            if (!context.mounted) return;

                            if (viewModel.state.canRegisterFacilty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      NurseSelectionPage(facility: facility),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 32,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEFF6FF),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.calendar_month_outlined,
                                            size: 44,
                                            color: Color(0xFF003178),
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        const Text(
                                          'Sin enfermeros/as\ndisponibles',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF003178),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Actualmente, todo el personal de enfermería registrado ha sido asignado a una posta médica. Por favor, espere al registro de nuevo personal.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF6B7D8F),
                                            height: 1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        const Divider(color: Color(0xFFE2E8F0)),
                                        const SizedBox(height: 8),
                                        TextButton.icon(
                                          onPressed: () => Navigator.pop(ctx),
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Color(0xFF003178),
                                            size: 18,
                                          ),
                                          label: const Text(
                                            'Cerrar',
                                            style: TextStyle(
                                              color: Color(0xFF003178),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003178),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    icon: isLoadingNurseAvailability
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.medical_services_outlined, size: 18),
                    label: Text(
                      isLoadingNurseAvailability
                          ? 'Verificando...'
                          : 'Asignar Enfermero',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
