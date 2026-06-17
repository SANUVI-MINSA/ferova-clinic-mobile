import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/district.dart';
import 'package:flutter/material.dart';

class GeneralInfoStep extends StatelessWidget {
  final TextEditingController facilityNameController;
  final TextEditingController addressController;
  final TextEditingController phoneNumberController;
  final List<District> districts;
  final bool isLoadingDistricts;
  final String? selectedDistrictId;
  final ValueChanged<String?> onDistrictChanged;

  const GeneralInfoStep({
    super.key,
    required this.facilityNameController,
    required this.addressController,
    required this.phoneNumberController,
    required this.districts,
    required this.isLoadingDistricts,
    required this.selectedDistrictId,
    required this.onDistrictChanged,
  });

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
          // Header
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

          // Nombre de la Posta
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
            controller: facilityNameController,
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

          // Distrito
          const Text(
            'Distrito *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          isLoadingDistricts
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
                      value: selectedDistrictId,
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
                      items: districts.map((district) {
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
                      onChanged: onDistrictChanged,
                    ),
                  ),
                ),
          const SizedBox(height: 18),

          // Dirección Completa
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
            controller: addressController,
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

          // Teléfono de Contacto
          const Text(
            'Teléfono de Contacto',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '+51 000-000-000',
              hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: Color(0xFF6B7D8F),
                size: 20,
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
