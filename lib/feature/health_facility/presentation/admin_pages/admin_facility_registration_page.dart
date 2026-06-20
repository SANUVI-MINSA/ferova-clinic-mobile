import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/district.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/confirmed_admin_facility_registration_page.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/general_info_step.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/map_location_step.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/services_selection_step.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/time_selection_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminFacilityRegistrationPage extends StatefulWidget {
  const AdminFacilityRegistrationPage({super.key});

  @override
  State<AdminFacilityRegistrationPage> createState() =>
      _AdminFacilityRegistrationPageState();
}

class _AdminFacilityRegistrationPageState
    extends State<AdminFacilityRegistrationPage> {
  int _currentStep = 0;
  final int _totalSteps = 4;
  double _previousProgress = 0;

  double get _progress => (_currentStep + 1) / _totalSteps;

  final TextEditingController _facilityNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isGeneralInfoValid = false;
  String? _selectedDistrictId;
  bool _isLoadingAddress = false;
  double? _latitude;
  double? _longitude;
  bool _isServicesValid = false;
  List<String> _services = [];
  bool _isTimeSelectionValid = false;
  List<String> _availableDays = [];
  List<String> _availableSlots = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminFacilityViewModel>().getDistricts();
    });
  }

  @override
  void dispose() {
    _facilityNameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _previousProgress = _progress;
        _currentStep++;
      });
    } else {
      _showConfirmationDialog();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _previousProgress = _progress;
        _currentStep--;
      });
    }
  }

  bool _isNextButtonDisabled() {
    if (_currentStep == 0 && !_isGeneralInfoValid) return true;
    if (_currentStep == 1 && _isLoadingAddress) return true;
    if (_currentStep == 2 && !_isServicesValid) return true;
    if (_currentStep == 3 && !_isTimeSelectionValid) return true;
    return false;
  }

  void _showConfirmationDialog() {
    const Map<String, String> dayTranslations = {
      'Monday': 'Lunes',
      'Tuesday': 'Martes',
      'Wednesday': 'Miércoles',
      'Thursday': 'Jueves',
      'Friday': 'Viernes',
      'Saturday': 'Sábado',
      'Sunday': 'Domingo',
    };

    final String daysInSpanish = _availableDays
        .map((d) => dayTranslations[d] ?? d)
        .join(', ');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '¿Confirmar registro?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Revisa los datos antes de registrar la posta.',
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7D8F)),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFFE2E8F0)),
            const SizedBox(height: 12),
            _buildSummaryRow('Nombre', _facilityNameController.text),
            _buildSummaryRow('Dirección', _addressController.text),
            _buildSummaryRow('Teléfono', '+51${_phoneNumberController.text}'),
            _buildSummaryRow('Servicios', _services.join(', ')),
            _buildSummaryRow('Días', daysInSpanish),
            _buildSummaryRow('Horarios', _availableSlots.join(', ')),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Editar',
                      style: TextStyle(color: Color(0xFF6B7D8F)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _submitRegistration();
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
                    child: const Text(
                      'Confirmar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Color(0xFF1A1A2E)),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value.isEmpty ? '—' : value),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRegistration() async {
    final String fullPhoneNumber = '+51${_phoneNumberController.text.trim()}';
    final viewModel = context.read<AdminFacilityViewModel>();

    await viewModel.registerAdminFacility(
      _facilityNameController.text.trim(),
      _addressController.text.trim(),
      _selectedDistrictId!,
      _latitude!,
      _longitude!,
      fullPhoneNumber,
      _services,
      _availableDays,
      _availableSlots,
    );

    if (!mounted) return;

    if (viewModel.state.isAdminFacilityRegistered) {
      final String districtName = viewModel.state.districts
          .firstWhere(
            (d) => d.id == _selectedDistrictId,
            orElse: () => District(id: '', name: '—'),
          )
          .name;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ConfirmedAdminFacilityRegistrationPage(
            message: viewModel.state.registrationMessage ?? '',
            facilityName: _facilityNameController.text.trim(),
            address: _addressController.text.trim(),
            phoneNumber: '+51${_phoneNumberController.text.trim()}',
            districtName: districtName,
            services: _services,
            availableDays: _availableDays,
            availableSlots: _availableSlots,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.state.errorMessage ?? 'Error al registrar la posta',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context
        .watch<AdminFacilityViewModel>()
        .state
        .isLoadingAdminFacilityRegistration;

    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF003178)),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Registrar Posta',
              style: TextStyle(
                color: Color(0xFF003178),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          body: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: _previousProgress, end: _progress),
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: const Color(0xFFE2E8F0),
                    color: const Color(0xFF003178),
                    minHeight: 6,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Paso ${_currentStep + 1} de $_totalSteps',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7D8F),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(_currentStep),
                      child: _buildStepContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFF003178)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Atrás',
                        style: TextStyle(color: Color(0xFF003178)),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isNextButtonDisabled() ? null : _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isNextButtonDisabled()
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFF003178),
                      foregroundColor: _isNextButtonDisabled()
                          ? const Color(0xFF9EAFC0)
                          : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentStep < _totalSteps - 1
                          ? 'Siguiente'
                          : 'Finalizar',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Overlay de loading
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Registrando posta...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        final state = context.watch<AdminFacilityViewModel>().state;
        return GeneralInfoStep(
          facilityNameController: _facilityNameController,
          addressController: _addressController,
          phoneNumberController: _phoneNumberController,
          districts: state.districts,
          isLoadingDistricts: state.isLoadingDistricts,
          selectedDistrictId: _selectedDistrictId,
          onDistrictChanged: (value) =>
              setState(() => _selectedDistrictId = value),
          onValidationChanged: (isValid) {
            setState(() => _isGeneralInfoValid = isValid);
          },
        );
      case 1:
        return MapLocationStep(
          initialLatitude: _latitude,
          initialLongitude: _longitude,
          onLocationChanged: (location) {
            _latitude = location.latitude;
            _longitude = location.longitude;
          },
          onAddressLoadingChanged: (isLoading) {
            if (mounted) {
              setState(() => _isLoadingAddress = isLoading);
            }
          },
        );
      case 2:
        return ServicesSelectionStep(
          selectedServices: _services,
          onServicesChanged: (updated) {
            _services = updated;
          },
          onValidationChanged: (isValid) {
            setState(() => _isServicesValid = isValid);
          },
        );
      case 3:
        return TimeSelectionStep(
          selectedDays: _availableDays,
          selectedSlots: _availableSlots,
          onDaysChanged: (updated) => _availableDays = updated,
          onSlotsChanged: (updated) => _availableSlots = updated,
          onValidationChanged: (isValid) {
            setState(() => _isTimeSelectionValid = isValid);
          },
        );
      default:
        return const SizedBox();
    }
  }
}
