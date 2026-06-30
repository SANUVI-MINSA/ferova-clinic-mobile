import 'package:ferova_clinic_flutter/feature/treatment/presentation/treatments_list/treatment_card.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/treatments_list/treatments_list_state.dart';
import 'package:ferova_clinic_flutter/feature/treatment/presentation/treatments_list/treatments_list_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../domain/repositories/treatment_repository.dart';

class TreatmentsListPage extends StatelessWidget {
  const TreatmentsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TreatmentsListViewModel(
        repository: getIt<TreatmentRepository>(),
      ),
      child: const _TreatmentsListContent(),
    );
  }
}

class _TreatmentsListContent extends StatelessWidget {
  const _TreatmentsListContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TreatmentsListViewModel>();
    final state = viewModel.state;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mis Tratamientos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D6EA8),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildFilterChips(viewModel, state),
          const SizedBox(height: 8),
          Expanded(
            child: state.isLoading
                ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0D6EA8)),
            )
                : state.errorMessage != null
                ? _buildErrorWidget(state.errorMessage!, viewModel)
                : state.treatments.isEmpty
                ? _buildEmptyWidget()
                : _buildTreatmentList(viewModel, state),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(TreatmentsListViewModel viewModel, TreatmentsListState state) {
    final filters = ['TODOS', 'ACTIVE', 'COMPLETED', 'ABANDONED'];
    final labels = ['Todos', 'Activos', 'Completados', 'Abandonados'];
    final counts = [
      state.treatments.length,
      state.activeCount,
      state.completedCount,
      state.abandonedCount,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Aumentado el padding horizontal
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(filters.length, (index) {
            final currentFilter = filters[index];
            final isSelected = (currentFilter == 'TODOS' && state.selectedFilter == 'TODOS') ||
                (currentFilter != 'TODOS' && state.selectedFilter == currentFilter) ||
                (state.selectedFilter == null && currentFilter == 'TODOS');

            return Padding(
              padding: const EdgeInsets.only(right: 8), // Aumentado el espacio entre chips
              child: FilterChip(
                label: Text(
                  '${labels[index]} (${counts[index]})',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) {
                  if (currentFilter == 'TODOS') {
                    viewModel.clearFilter();
                  } else {
                    viewModel.filterByStatus(currentFilter);
                  }
                },
                selectedColor: const Color(0xFF0D6EA8).withValues(alpha: 0.15),
                backgroundColor: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF0D6EA8)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                visualDensity: VisualDensity.compact,
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error, TreatmentsListViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los tratamientos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => viewModel.loadTreatments(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EA8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_information_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes tratamientos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aún no has iniciado ningún tratamiento.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentList(TreatmentsListViewModel viewModel, TreatmentsListState state) {
    final filtered = state.filteredTreatments;

    return RefreshIndicator(
      color: const Color(0xFF0D6EA8),
      onRefresh: () => viewModel.loadTreatments(status: state.selectedFilter),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final treatment = filtered[index];
          return TreatmentCard(
            treatment: treatment,
            onTap: () => viewModel.viewTreatmentDetails(
              context,
              treatment.treatmentId,
            ),
          );
        },
      ),
    );
  }
}