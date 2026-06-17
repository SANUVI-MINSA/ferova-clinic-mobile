import 'package:flutter/material.dart';

class ServicesSelectionStep extends StatefulWidget {
  final List<String> selectedServices;
  final ValueChanged<List<String>> onServicesChanged;

  const ServicesSelectionStep({
    super.key,
    required this.selectedServices,
    required this.onServicesChanged,
  });

  @override
  State<ServicesSelectionStep> createState() => _ServicesSelectionStepState();
}

class _ServicesSelectionStepState extends State<ServicesSelectionStep> {
  final List<_ServiceOption> _defaultServices = const [
    _ServiceOption(name: 'Vacunación', icon: Icons.vaccines_outlined),
    _ServiceOption(name: 'Pediatría', icon: Icons.child_care_outlined),
    _ServiceOption(
      name: 'Medicina General',
      icon: Icons.health_and_safety_outlined,
    ),
    _ServiceOption(name: 'Enfermería', icon: Icons.healing_outlined),
  ];

  final List<String> _customServices = [];

  final TextEditingController _customServiceController =
      TextEditingController();

  @override
  void dispose() {
    _customServiceController.dispose();
    super.dispose();
  }

  bool _isSelected(String serviceName) {
    return widget.selectedServices.contains(serviceName);
  }

  void _toggleService(String serviceName) {
    final List<String> updated = List<String>.from(widget.selectedServices);

    if (updated.contains(serviceName)) {
      updated.remove(serviceName);
      _customServices.remove(serviceName);
    } else {
      updated.add(serviceName);
    }

    widget.onServicesChanged(updated);
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

    setState(() {
      _customServices.add(value);
      _customServiceController.clear();
    });
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
          // Header
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
                    return _ServiceCheckboxTile(
                      label: service.name,
                      icon: service.icon,
                      isSelected: _isSelected(service.name),
                      onTap: () => _toggleService(service.name),
                    );
                  }),

                  ..._customServices.map((service) {
                    return _AnimatedServiceTile(
                      key: ValueKey(service),
                      label: service,
                      icon: Icons.add_circle_outline,
                      isSelected: _isSelected(service),
                      onTap: () => _toggleService(service),
                    );
                  }),
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

class _ServiceOption {
  final String name;
  final IconData icon;

  const _ServiceOption({required this.name, required this.icon});
}

class _ServiceCheckboxTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceCheckboxTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            IgnorePointer(
              child: Checkbox(
                value: isSelected,
                onChanged: (_) {},
                activeColor: const Color(0xFF003178),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ),
            Icon(icon, color: const Color(0xFF6B7D8F), size: 22),
          ],
        ),
      ),
    );
  }
}

class _AnimatedServiceTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimatedServiceTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 1, end: 1),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) => child!,
      child: _ServiceCheckboxTile(
        label: label,
        icon: icon,
        isSelected: isSelected,
        onTap: onTap,
      ),
    );
  }
}
