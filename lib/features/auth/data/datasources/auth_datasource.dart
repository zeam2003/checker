import 'package:dio/dio.dart';

class AuthDatasource {
  final Dio _dio;

  AuthDatasource(this._dio);

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'https://demo.ecosistemasglobal.com/api/v1/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Error en la autenticación');
    } catch (e) {
      throw Exception('Error inesperado');
    }
  }
}