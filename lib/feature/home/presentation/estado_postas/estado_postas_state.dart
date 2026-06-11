import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';

class EstadoPostasState {
  final bool isLoading;
  final String? errorMessage;
  final List<Posta> postas;

  const EstadoPostasState({
    this.isLoading = false,
    this.errorMessage,
    this.postas = const [],
  });

  EstadoPostasState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Posta>? postas,
  }) {
    return EstadoPostasState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      postas: postas ?? this.postas,
    );
  }
}
