import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/value_objects/service_option.dart';
import 'package:ferova_clinic_flutter/feature/health_facility/presentation/admin_pages/service_checkbox_tile.dart';
import 'package:flutter/material.dart';

class ServicesSelectionStep extends StatefulWidget {
  final List<String> selectedServices;
  final ValueChanged<List<String>> onServicesChanged;
  final ValueChanged<bool> onValidationChanged;

  const ServicesSelectionStep({
    super.key,
    required this.selectedServices,
    required this.onServicesChanged,
    required this.onValidationChanged,
  });

  @override
  State<ServicesSelectionStep> createState() => _ServicesSelectionStepState();
}

class _ServicesSelectionStepState extends State<ServicesSelectionStep> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ServiceOption> _defaultServices = const [
    ServiceOption(name: 'Vacunación', icon: Icons.vaccines_outlined),
    ServiceOption(name: 'Pediatría', icon: Icons.child_care_outlined),
    ServiceOption(
      name: 'Medicina General',
      icon: Icons.health_and_safety_outlined,
    ),
    ServiceOption(name: 'Enfermería', icon: Icons.healing_outlined),
  ];

  final List<String> _customServices = [];
  final TextEditingController _customServiceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Valida apenas se monta, por si ya hay servicios seleccionados (al regresar de otro step)
    Future.microtask(() {
      if (mounted) _validate();
    });
  }

  @override
  void dispose() {
    _customServiceController.dispose();
    super.dispose();
  }

  void _validate() {
    widget.onValidationChanged(widget.selectedServices.isNotEmpty);
  }

  bool _isSelected(String serviceName) {
    return widget.selectedServices.contains(serviceName);
  }

  void _toggleService(String serviceName) {
    final List<String> updated = List<String>.from(widget.selectedServices);

    if (updated.contains(serviceName)) {
      updated.remove(serviceName);

      final int customIndex = _customServices.indexOf(serviceName);
      if (customIndex != -1) {
        final String removedService = _customServices[customIndex];
        _customServices.removeAt(customIndex);

        _listKey.currentState?.removeItem(
          customIndex,
          (context, animation) =>
              _buildAnimatedTile(removedService, animation, isRemoving: true),
          duration: const Duration(milliseconds: 300),
        );
      }
    } else {
      updated.add(serviceName);
    }

    widget.onServicesChanged(updated);
    _validate();
    setState(() {});
  }

  void _addCustomService() {
    final String value = _customServiceController.text.trim();
    if (value.isEmpty) return;

    if (_customServices.contains(value) ||
        _defaultServices.any((s) => s.name == value)) {
      _customServiceController.clear();
      return;
    }

    final List<String> updated = List<String>.from(widget.selectedServices)
      ..add(value);
    widget.onServicesChanged(updated);
    _validate();

    setState(() {
      _customServices.add(value);
      _customServiceController.clear();
    });

    _listKey.currentState?.insertItem(
      _customServices.length - 1,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildAnimatedTile(
    String service,
    Animation<double> animation, {
    bool isRemoving = false,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      fixedCrossAxisSizeFactor: 1.0,
      child: FadeTransition(
        opacity: animation,
        child: ServiceCheckboxTile(
          label: service,
          icon: Icons.add_circle_outline,
          isSelected: isRemoving ? true : _isSelected(service),
          onTap: () => _toggleService(service),
        ),
      ),
    );
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
                Icons.medical_services_outlined,
                color: Color(0xFF003178),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Servicios',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 320),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ..._defaultServices.map((service) {
                    return ServiceCheckboxTile(
                      label: service.name,
                      icon: service.icon,
                      isSelected: _isSelected(service.name),
                      onTap: () => _toggleService(service.name),
                    );
                  }),
                  SizedBox(
                    height: _customServices.length * 60.0,
                    child: AnimatedList(
                      key: _listKey,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      initialItemCount: _customServices.length,
                      itemBuilder: (context, index, animation) {
                        final String service = _customServices[index];
                        return _buildAnimatedTile(service, animation);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 16),

          const Text(
            'Agregar otro servicio',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customServiceController,
                  onSubmitted: (_) => _addCustomService(),
                  decoration: InputDecoration(
                    hintText: 'Ej: Odontología',
                    hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
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
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: _addCustomService,
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF003178),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(14),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
