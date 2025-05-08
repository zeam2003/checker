import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../domain/models/check_model.dart';

class CheckDatasource {
  final Dio _dio;

  CheckDatasource(this._dio);

  Future<Map<String, dynamic>> createCheck(
    String ticketId, {
    required String type,
    required int glpiID,
    required int createdBy,
    required String token,
  }) async {
    try {
      final data = {
        'ticketId': ticketId,
        'type': type,
        'glpiID': glpiID,
        'createdBy': createdBy,
        'stage': 1,
        'status': 'en_curso',
      };

      debugPrint('=== ENVIANDO SOLICITUD AL SERVIDOR ===');
      debugPrint('URL: https://demo.ecosistemasglobal.com/api/v1/checks');
      debugPrint('Token: Bearer $token');
      debugPrint('Body: $data');

      final response = await _dio.post(
        'https://demo.ecosistemasglobal.com/api/v1/checks',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint('=== RESPUESTA DEL SERVIDOR ===');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Data: ${response.data}');

      return response.data;
    } catch (e) {
      debugPrint('=== ERROR EN LA SOLICITUD ===');
      if (e is DioException) {
        debugPrint('Status Code: ${e.response?.statusCode}');
        debugPrint('Error Data: ${e.response?.data}');
        debugPrint('Error Message: ${e.message}');
      }
      rethrow;
    }
  }
}