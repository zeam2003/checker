import 'package:dio/dio.dart';
import '../../domain/models/user_checks.dart';

class ChecksRepository {
  final Dio _dio;

  ChecksRepository(this._dio);

  Future<UserChecks> getUserChecks(int userId, String token) async {
    try {
      final response = await _dio.get(
        '/api/v1/checks/user/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return UserChecks.fromJson(response.data as List);
    } catch (e) {
      throw Exception('Error al obtener los chequeos del usuario: $e');
    }
  }
}