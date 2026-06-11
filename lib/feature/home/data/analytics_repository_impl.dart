import 'dart:typed_data';

import 'package:ferova_clinic_flutter/feature/home/domain/analytics_repository.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/dashboard_summary.dart';
import 'package:ferova_clinic_flutter/feature/home/domain/posta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'analytics_service.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsService service;

  const AnalyticsRepositoryImpl({required this.service});

  Future<String> _token() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    final token = await _token();
    final dto = await service.getDashboardSummary(token);
    return dto?.toDomain() ?? DashboardSummary.empty;
  }

  @override
  Future<List<Posta>> getTopFacilities() async {
    final token = await _token();
    final dtos = await service.getTopFacilities(token);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Posta>> getAllFacilities() async {
    final token = await _token();
    final dtos = await service.getAllFacilities(token);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Posta>> getHeatmapPoints() async {
    final token = await _token();
    final dtos = await service.getHeatmapPoints(token);
    return dtos.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Uint8List?> getReportPdf() async {
    final token = await _token();
    return service.getReportPdf(token);
  }
}
