import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/admin_facility.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/nurse.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_state.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
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
      body: state.isLoadingAvailableNurses
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF003178)),
            )
          : state.errorMessage != null
          ? Center(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enfermeros Disponibles',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.availableNurses.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final Nurse nurse = state.availableNurses[index];
                            final bool isSelected =
                                _selectedNurse?.id == nurse.id;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedNurse =
                                      (_selectedNurse?.id == nurse.id)
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
                                    width: 1.5,
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
                      ],
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
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: confirmar asignación
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
                            icon: const Icon(
                              Icons.person_add_outlined,
                              size: 20,
                            ),
                            label: const Text(
                              'Confirmar Asignación',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
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
