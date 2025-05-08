import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../domain/models/check_model.dart';
import '../../domain/repositories/check_repository.dart';
import '../datasources/check_datasource.dart';

// Creamos una clase de error personalizada
class CheckError implements Exception {
  final String message;
  
  CheckError(this.message);
  
  @override
  String toString() => message;
}

class CheckRepositoryImpl implements CheckRepository {
  final CheckDatasource _datasource;
  final String _token;

  CheckRepositoryImpl(this._datasource, this._token);

  @override
  Future<CheckModel> createCheck(
    String ticketId, {
    required String type,
    required int glpiID,
    required int createdBy,
  }) async {
    try {
      debugPrint('=== CREANDO CHECK EN REPOSITORY ===');
      debugPrint('Ticket ID: $ticketId');
      debugPrint('Type: $type');
      debugPrint('GLPI ID: $glpiID');
      debugPrint('Created By: $createdBy');
      
      final response = await _datasource.createCheck(
        ticketId,
        type: type,
        glpiID: glpiID,
        createdBy: createdBy,
        token: _token,
      );
      
      return CheckModel.fromJson(response);
    } catch (e) {
      debugPrint('=== ERROR EN REPOSITORY ===');
      if (e is DioException && e.response?.statusCode == 409) {
        final errorData = e.response?.data;
        debugPrint('Error 409 detectado: $errorData');
        
        // Extraemos el ID del ticket del mensaje original
        final String message = (errorData as Map<String, dynamic>)['message'] ?? '';
        final RegExp regExp = RegExp(r'\d+');
        final String ticketId = regExp.firstMatch(message)?.group(0) ?? '';
        
        // Usamos nuestra clase de error personalizada
        throw CheckError('Error: Ya existe un check para el Ticket #$ticketId');
      }
      debugPrint(e.toString());
      rethrow;
    }
  }
}