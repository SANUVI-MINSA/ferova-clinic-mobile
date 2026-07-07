import 'dart:async';

import 'package:ferova_clinic_flutter/feature/communication/presentation/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/model/value-objects/consultations_inbox_result.dart';
import 'consultation_tile.dart';
import 'consultations_inbox_state.dart';
import 'consultations_inbox_view_model.dart';
import 'no_consultations_empty_state.dart';
import 'no_patients_assigned_empty_state.dart';
import 'no_search_results_empty_state.dart';

const _navy = Color(0xFF1A3A5C);
const _accentBlue = Color(0xFF0D6EA8);
const _background = Color(0xFFF0F4F8);
const _mutedGrey = Color(0xFF6B7D8F);

class ConsultationsInboxPage extends StatefulWidget {
  final String nurseId;
  final VoidCallback? onGoToPatients;

  const ConsultationsInboxPage({
    super.key,
    required this.nurseId,
    this.onGoToPatients,
  });

  @override
  State<ConsultationsInboxPage> createState() =>
      _ConsultationsInboxPageState();
}

class _ConsultationsInboxPageState extends State<ConsultationsInboxPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _load({String? searchTerm}) {
    print('🔄 Recargando bandeja de consultas...');
    context.read<ConsultationsInboxViewModel>().getConsultations(
      searchTerm: searchTerm ?? _searchController.text,
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _load(searchTerm: value);
    });
  }

  void _navigateToChat(String consultationId) async {
    // ✅ Esperar el resultado del chat
    final shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          consultationId: consultationId,
          nurseId: widget.nurseId,
        ),
      ),
    );

    // ✅ SIEMPRE recargar al volver del chat
    if (mounted) {
      print('🔄 Recargando después de volver del chat...');
      _load();

      // ✅ Mostrar feedback si se cerró la consulta
      if (shouldRefresh == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Consulta cerrada exitosamente'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = context.watch<ConsultationsInboxViewModel>();
    final state = viewModel.state;

    // ✅ Debug: imprimir estado actual
    print('📊 Estado actual: ${state.result?.status}');
    print('📊 Cantidad de consultas: ${state.result?.consultations.length ?? 0}');

    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Consultas',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Buscar por paciente o madre',
                  hintStyle: const TextStyle(color: _mutedGrey, fontSize: 14),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: _mutedGrey,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear_rounded, color: _mutedGrey),
                    onPressed: () {
                      _searchController.clear();
                      _load(searchTerm: '');
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildBody(state)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ConsultationsInboxState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: _accentBlue),
      );
    }

    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 56, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Error: ${state.errorMessage}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _load(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentBlue,
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

    final result = state.result;
    if (result == null) {
      return const Center(
        child: CircularProgressIndicator(color: _accentBlue),
      );
    }

    switch (result.status) {
      case ConsultationsInboxStatus.hasConsultations:
        if (result.consultations.isEmpty) {
          return NoConsultationsEmptyState(
            message: 'No hay consultas activas',
            detail: 'Todas las consultas han sido cerradas',
          );
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: result.consultations.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final consultation = result.consultations[index];
            return ConsultationTile(
              consultation: consultation,
              onTap: () => _navigateToChat(consultation.consultationId),
            );
          },
        );

      case ConsultationsInboxStatus.noConsultations:
        return NoConsultationsEmptyState(
          message: result.message ?? 'No tienes consultas activas',
          detail: result.detail,
        );

      case ConsultationsInboxStatus.noPatients:
        return NoPatientsAssignedEmptyState(
          message: result.message ?? 'No tienes pacientes asignados',
          detail: result.detail,
          onGoToPatients: widget.onGoToPatients,
        );

      case ConsultationsInboxStatus.noSearchResults:
        return NoSearchResultsEmptyState(
          searchTerm: result.searchTerm,
          message: result.message,
          detail: result.detail,
        );
    }
  }
}