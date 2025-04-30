import 'package:dio/dio.dart';

class TicketDatasource {
  final Dio _dio;

  TicketDatasource(this._dio);

  Future<Map<String, dynamic>> validateTicket(String ticketId, String token) async {
    try {
      print('Validando ticket con ID: $ticketId');
      print('Token utilizado: Bearer $token');
      
      final response = await _dio.get(
        'https://demo.ecosistemasglobal.com/api/v1/auth/tickets/$ticketId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      print('Respuesta del servidor (validateTicket):');
      print(response.data);
      
      return response.data;
    } on DioException catch (e) {
      print('Error DioException en validateTicket:');
      print('StatusCode: ${e.response?.statusCode}');
      print('Mensaje de error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Error al validar el ticket');
    } catch (e) {
      print('Error inesperado en validateTicket:');
      print(e.toString());
      throw Exception('Error inesperado al validar el ticket');
    }
  }

  Future<Map<String, dynamic>> getTicketItems(String ticketId, String token) async {
    try {
      print('Obteniendo items del ticket: $ticketId');
      print('Token utilizado: Bearer $token');
      
      final response = await _dio.get(
        'https://demo.ecosistemasglobal.com/api/v1/auth/tickets/$ticketId/items',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      print('Respuesta del servidor (getTicketItems):');
      print(response.data);
      
      return response.data;
    } catch (e) {
      if (e is DioException) {
        print('Error DioException en getTicketItems:');
        print('StatusCode: ${e.response?.statusCode}');
        print('Mensaje de error: ${e.response?.data}');
        return {
          'statusCode': e.response?.statusCode ?? 500,
          'message': e.response?.data['message'] ?? 'Error al obtener items del ticket',
        };
      }
      print('Error inesperado en getTicketItems:');
      print(e.toString());
      return {
        'statusCode': 500,
        'message': 'Error al obtener items del ticket',
      };
    }
  }
}