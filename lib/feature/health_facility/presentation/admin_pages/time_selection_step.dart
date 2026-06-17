import 'package:ferova_clinic_flutter/feature/health_facility/domain/model/value_objects/day_option.dart';
import 'package:flutter/material.dart';

class TimeSelectionStep extends StatefulWidget {
  final List<String> selectedDays;
  final List<String> selectedSlots;
  final ValueChanged<List<String>> onDaysChanged;
  final ValueChanged<List<String>> onSlotsChanged;
  final ValueChanged<bool> onValidationChanged;

  const TimeSelectionStep({
    super.key,
    required this.selectedDays,
    required this.selectedSlots,
    required this.onDaysChanged,
    required this.onSlotsChanged,
    required this.onValidationChanged,
  });

  @override
  State<TimeSelectionStep> createState() => _TimeSelectionStepState();
}

class _TimeSelectionStepState extends State<TimeSelectionStep> {
  final List<DayOption> _days = const [
    DayOption(value: 'Monday', label: 'L'),
    DayOption(value: 'Tuesday', label: 'M'),
    DayOption(value: 'Wednesday', label: 'X'),
    DayOption(value: 'Thursday', label: 'J'),
    DayOption(value: 'Friday', label: 'V'),
    DayOption(value: 'Saturday', label: 'S'),
    DayOption(value: 'Sunday', label: 'D'),
  ];

  // Slots de 00:00 a 23:00
  late final List<String> _slots = List.generate(
    24,
    (index) => '${index.toString().padLeft(2, '0')}:00',
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) _validate();
    });
  }

  void _validate() {
    final bool isValid =
        widget.selectedDays.isNotEmpty && widget.selectedSlots.isNotEmpty;
    widget.onValidationChanged(isValid);
  }

  void _toggleDay(String dayValue) {
    final List<String> updated = List<String>.from(widget.selectedDays);
    if (updated.contains(dayValue)) {
      updated.remove(dayValue);
    } else {
      updated.add(dayValue);
    }
    widget.onDaysChanged(updated);

    final bool isValid = updated.isNotEmpty && widget.selectedSlots.isNotEmpty;
    widget.onValidationChanged(isValid);

    setState(() {});
  }

  void _toggleSlot(String slot) {
    final List<String> updated = List<String>.from(widget.selectedSlots);
    if (updated.contains(slot)) {
      updated.remove(slot);
    } else {
      updated.add(slot);
    }
    widget.onSlotsChanged(updated);

    final bool isValid = widget.selectedDays.isNotEmpty && updated.isNotEmpty;
    widget.onValidationChanged(isValid);

    setState(() {});
  }

  bool _isDaySelected(String dayValue) =>
      widget.selectedDays.contains(dayValue);
  bool _isSlotSelected(String slot) => widget.selectedSlots.contains(slot);

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
                Icons.calendar_month_outlined,
                color: Color(0xFF003178),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Disponibilidad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Días de la semana
          const Text(
            'Días de atención *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: _days.map((day) {
              final bool isSelected = _isDaySelected(day.value);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () => _toggleDay(day.value),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF003178)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF003178)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF9EAFC0),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 20),

          // Slots de atención
          const Text(
            'Slots de Atención (HH:MM) *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),

          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 280),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _slots.map((slot) {
                  final bool isSelected = _isSlotSelected(slot);
                  return GestureDetector(
                    onTap: () => _toggleSlot(slot),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 92,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF003178)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF003178)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7D8F),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
