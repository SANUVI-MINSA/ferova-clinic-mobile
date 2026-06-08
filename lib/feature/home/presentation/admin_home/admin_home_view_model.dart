import 'package:flutter/material.dart';
import 'package:ferova_clinic_flutter/feature/auth/domain/user.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';
import 'admin_home_state.dart';

class AdminHomeViewModel extends ChangeNotifier {
  AdminHomeState _state = const AdminHomeState();
  AdminHomeState get state => _state;

  void init(User user) {
    _state = _state.copyWith(user: user, isLoading: true);
    notifyListeners();
    _loadData();
  }

  Future<void> refresh() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();
    _loadData();
  }

  void _loadData() {
    final postas = [
      const Posta(
        id: '1',
        name: 'Posta Huascar',
        coveragePercentage: 30,
        status: PostaStatus.critico,
        location: 'San Juan Lurigancho',
        latitude: -12.148,
        longitude: -77.022,
      ),
      const Posta(
        id: '2',
        name: 'Posta San Hilarion',
        coveragePercentage: 42,
        status: PostaStatus.critico,
        location: 'San Juan Lurigancho',
        latitude: -12.120,
        longitude: -77.044,
      ),
      const Posta(
        id: '3',
        name: 'Posta Zarate',
        coveragePercentage: 65,
        status: PostaStatus.moderado,
        location: 'San Juan Lurigancho',
        latitude: -12.062,
        longitude: -77.055,
      ),
      const Posta(
        id: '4',
        name: 'Posta Canto Grande',
        coveragePercentage: 80,
        status: PostaStatus.bajo,
        location: 'San Juan Lurigancho',
        latitude: -12.075,
        longitude: -77.093,
      ),
    ];

    _state = _state.copyWith(
      isLoading: false,
      postas: postas,
      globalCoverage: 54.25,
      postasActivas: 4,
      postasConAlerta: 2,
    );
    notifyListeners();
  }
}
