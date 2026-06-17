import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/admin_facility_view_model.dart';
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
      // TODO: enviar registro completo
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminFacilityViewModel>().getDistricts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  _currentStep < _totalSteps - 1 ? 'Siguiente' : 'Finalizar',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
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
