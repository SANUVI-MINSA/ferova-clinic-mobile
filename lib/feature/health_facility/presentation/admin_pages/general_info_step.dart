import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/district.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GeneralInfoStep extends StatefulWidget {
  final TextEditingController facilityNameController;
  final TextEditingController addressController;
  final TextEditingController phoneNumberController;
  final List<District> districts;
  final bool isLoadingDistricts;
  final String? selectedDistrictId;
  final ValueChanged<String?> onDistrictChanged;
  final ValueChanged<bool> onValidationChanged;

  const GeneralInfoStep({
    super.key,
    required this.facilityNameController,
    required this.addressController,
    required this.phoneNumberController,
    required this.districts,
    required this.isLoadingDistricts,
    required this.selectedDistrictId,
    required this.onDistrictChanged,
    required this.onValidationChanged,
  });

  @override
  State<GeneralInfoStep> createState() => _GeneralInfoStepState();
}

class _GeneralInfoStepState extends State<GeneralInfoStep> {
  @override
  void initState() {
    super.initState();
    widget.facilityNameController.addListener(_validate);
    widget.addressController.addListener(_validate);
    widget.phoneNumberController.addListener(_validate);

    Future.microtask(() {
      if (mounted) _validate();
    });
  }

  @override
  void didUpdateWidget(GeneralInfoStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDistrictId != widget.selectedDistrictId) {
      Future.microtask(() {
        if (mounted) _validate();
      });
    }
  }

  @override
  void dispose() {
    widget.facilityNameController.removeListener(_validate);
    widget.addressController.removeListener(_validate);
    widget.phoneNumberController.removeListener(_validate);
    super.dispose();
  }

  void _validate() {
    final String phone = widget.phoneNumberController.text.trim();
    final bool isPhoneValid = RegExp(r'^\d{9}$').hasMatch(phone);

    final bool isValid =
        widget.facilityNameController.text.trim().isNotEmpty &&
        widget.selectedDistrictId != null &&
        widget.addressController.text.trim().isNotEmpty &&
        isPhoneValid;

    widget.onValidationChanged(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.info_outline_rounded,
                color: Color(0xFF003178),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Información General',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text(
            'Nombre de la Posta *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.facilityNameController,
            decoration: InputDecoration(
              hintText: 'Ej: Posta Sanitaria Norte',
              hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF003178)),
              ),
            ),
          ),
          const SizedBox(height: 18),

          const Text(
            'Distrito *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          widget.isLoadingDistricts
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF003178),
                      ),
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.selectedDistrictId,
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 14),
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF6B7D8F),
                        ),
                      ),
                      hint: const Text(
                        'Seleccionar Distrito',
                        style: TextStyle(color: Color(0xFF9EAFC0)),
                      ),
                      items: widget.districts.map((district) {
                        return DropdownMenuItem<String>(
                          value: district.id,
                          child: Text(
                            district.name,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: widget.onDistrictChanged,
                    ),
                  ),
                ),
          const SizedBox(height: 18),

          const Text(
            'Dirección Completa *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.addressController,
            maxLength: 30,
            decoration: InputDecoration(
              hintText: 'Calle, Número, Referencia',
              hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF003178)),
              ),
            ),
          ),
          const SizedBox(height: 18),

          const Text(
            'Teléfono de Contacto *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.phoneNumberController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            decoration: InputDecoration(
              hintText: '987654321',
              hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 14, right: 4),
                child: Icon(
                  Icons.phone_outlined,
                  color: Color(0xFF6B7D8F),
                  size: 20,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              prefix: const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Text(
                  '+51 ',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF003178)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
