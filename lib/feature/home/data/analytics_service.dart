import 'dart:convert';
import 'dart:io';
import 'package:ferova_clinic_flutter/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dto/dashboard_summary_dto.dart';
import 'dto/facility_dto.dart';
import 'dto/heatmap_point_dto.dart';

class AnalyticsService {
  final String _baseUrl = '${AppConfig.baseUrl}/analytics';

  Map<String, String> _headers(String token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // TPS-1: Dashboard summary
  Future<DashboardSummaryDto?> getDashboardSummary(String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/dashboard/summary');
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return DashboardSummaryDto.fromJson(json);
      }
      debugPrint('Summary error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('Summary network error: $e');
      return null;
    }
  }

  // TPS-2: Top facilities
  Future<List<FacilityDto>> getTopFacilities(String token) async {
    return _fetchFacilities('$_baseUrl/facilities/top', token);
  }

  // TPS-4: All facilities
  Future<List<FacilityDto>> getAllFacilities(String token) async {
    return _fetchFacilities('$_baseUrl/facilities', token);
  }

  Future<List<FacilityDto>> _fetchFacilities(String url, String token) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final list = (json['facilities'] as List<dynamic>? ?? []);
        return list
            .map((e) => FacilityDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      debugPrint('Facilities error ${response.statusCode}: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('Facilities network error: $e');
      return [];
    }
  }

  // Report PDF — devuelve los bytes del PDF
  Future<Uint8List?> getReportPdf(String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/report/pdf');
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        return response.bodyBytes;
      }
      debugPrint('PDF error ${response.statusCode}: ${response.body}');
      return null;
    } catch (e) {
      debugPrint('PDF network error: $e');
      return null;
    }
  }

  // TPS-3: Heatmap
  Future<List<HeatmapPointDto>> getHeatmapPoints(String token) async {
    try {
      final uri = Uri.parse('$_baseUrl/heatmap');
      final response = await http.get(uri, headers: _headers(token));

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final list = (json['points'] as List<dynamic>? ?? []);
        return list
            .map((e) => HeatmapPointDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      debugPrint('Heatmap error ${response.statusCode}: ${response.body}');
      return [];
    } catch (e) {
      debugPrint('Heatmap network error: $e');
      return [];
    }
  }
}
