import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_patients/mother_patients_page.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_search/mother_search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MotherSearchPage extends StatefulWidget {
  const MotherSearchPage({super.key});

  @override
  State<MotherSearchPage> createState() => _MotherSearchPageState();
}

class _MotherSearchPageState extends State<MotherSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final String search = _searchController.text.trim();
    if (search.isEmpty) {
      return;
    }

    final viewModel = context.read<MotherSearchViewModel>();
    final bool success = await viewModel.searchMotherByDni(search);

    if (!mounted || !success) {
      return;
    }

    final mother = viewModel.state.mother;
    if (mother == null) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MotherPatientsPage(
          motherId: mother.motherId,
          motherName: mother.fullName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MotherSearchViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Buscar Madre',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D6EA8),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ingresa el DNI o nombre de la madre',
                style: TextStyle(fontSize: 14, color: Color(0xFF1A3A5C)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: 'DNI o nombre...',
                  hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9EAFC0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.isLoading ? null : _search,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EA8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: state.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Buscar'),
                ),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 24),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontró la madre buscada.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
