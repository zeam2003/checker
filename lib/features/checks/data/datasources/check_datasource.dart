import 'package:dio/dio.dart';
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
      final response = await _dio.post(
        'https://demo.ecosistemasglobal.com/api/v1/checks',
        data: {
          'ticketId': ticketId,
          'type': type,
          'glpiID': glpiID,
          'createdBy': createdBy,
          'stage': 1,
          'status': 'en_curso',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}