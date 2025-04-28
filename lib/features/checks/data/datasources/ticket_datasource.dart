import 'package:dio/dio.dart';

class TicketDatasource {
  final Dio _dio;

  TicketDatasource(this._dio);

  Future<Map<String, dynamic>> validateTicket(String ticketId, String token) async {
    try {
      final response = await _dio.get(
        'https://demo.ecosistemasglobal.com/api/v1/auth/tickets/$ticketId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error al validar el ticket');
    } catch (e) {
      throw Exception('Error inesperado al validar el ticket');
    }
  }
}