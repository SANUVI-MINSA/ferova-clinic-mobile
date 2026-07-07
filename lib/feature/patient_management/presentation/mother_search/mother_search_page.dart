import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_patients/mother_patients_page.dart';
import 'package:ferova_clinic_flutter/feature/patient_management/presentation/mother_search/mother_search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/model/entities/mother.dart';
import 'mother_search_state.dart';

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
    await viewModel.searchMotherByDni(search);
  }

  void _navigateToMotherPatients(Mother mother) {
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (_) => _search(),
                      decoration: InputDecoration(
                        hintText: 'DNI o nombre...',
                        hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF9EAFC0),
                        ),
                        suffixIcon: state.isLoading
                            ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF0D6EA8),
                            ),
                          ),
                        )
                            : null,
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
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.isLoading ? null : _search,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EA8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          : const Icon(Icons.search_rounded),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildResults(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResults(MotherSearchState state) {
    // Estado de carga
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D6EA8)),
      );
    }

    // Error - No se encontró la madre
    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No se encontró la madre buscada.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Verifica que el DNI ingresado sea correcto.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  _searchController.clear();
                  context.read<MotherSearchViewModel>().clearSearch();
                },
                icon: const Icon(Icons.clear_rounded, size: 18),
                label: const Text('Limpiar búsqueda'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0D6EA8),
                  side: const BorderSide(color: Color(0xFF0D6EA8)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Mostrar resultados de búsqueda (madres encontradas)
    if (state.mothers.isNotEmpty) {
      return ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: state.mothers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final mother = state.mothers[index];
          return _MotherResultCard(
            mother: mother,
            onTap: () => _navigateToMotherPatients(mother),
          );
        },
      );
    }

    // Estado inicial - sin búsqueda
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_rounded,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Busca una madre por DNI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los resultados aparecerán aquí',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Card para mostrar el resultado de la búsqueda
class _MotherResultCard extends StatelessWidget {
  final Mother mother;
  final VoidCallback onTap;

  const _MotherResultCard({
    required this.mother,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF0D6EA8),
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mother.fullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A3A5C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'DNI: ${mother.dni}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7D8F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBF1FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Ver pacientes',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D6EA8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF0D6EA8),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}