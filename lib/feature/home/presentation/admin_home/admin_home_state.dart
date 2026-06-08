import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';

class AdminHomeState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final List<Posta> postas;
  final double globalCoverage;
  final int postasActivas;
  final int postasConAlerta;

  const AdminHomeState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.postas = const [],
    this.globalCoverage = 0.0,
    this.postasActivas = 0,
    this.postasConAlerta = 0,
  });

  AdminHomeState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    List<Posta>? postas,
    double? globalCoverage,
    int? postasActivas,
    int? postasConAlerta,
  }) {
    return AdminHomeState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      postas: postas ?? this.postas,
      globalCoverage: globalCoverage ?? this.globalCoverage,
      postasActivas: postasActivas ?? this.postasActivas,
      postasConAlerta: postasConAlerta ?? this.postasConAlerta,
    );
  }
}
