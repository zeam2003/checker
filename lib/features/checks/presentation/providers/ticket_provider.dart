import 'package:checker/features/checks/domain/models/check_model.dart';
import 'package:checker/features/checks/domain/models/ticket_model.dart';
import 'package:checker/features/checks/domain/repositories/check_repository.dart';
import 'package:checker/features/checks/domain/repositories/ticket_repository.dart';
import 'package:checker/features/checks/presentation/providers/check_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/dio_provider.dart';
import '../../data/datasources/ticket_datasource.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../../auth/presentation/providers/user_session_provider.dart';

final ticketRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final userSession = ref.watch(userSessionProvider);
  if (userSession == null) throw Exception('Usuario no autenticado');
  
  final datasource = TicketDatasource(dio);
  return TicketRepositoryImpl(datasource, userSession.sessionToken);
});

// Estado para el ticket
class TicketState {
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic>? ticketData;
  final Map<String, dynamic>? itemsData;
  final String? deviceType;  // Nuevo campo para almacenar el tipo de dispositivo

  TicketState({
    this.isLoading = false,
    this.errorMessage,
    this.ticketData,
    this.itemsData,
    this.deviceType,
  });

  TicketState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? ticketData,
    Map<String, dynamic>? itemsData,
    String? deviceType,
  }) {
    return TicketState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      ticketData: ticketData ?? this.ticketData,
      itemsData: itemsData ?? this.itemsData,
      deviceType: deviceType ?? this.deviceType,
    );
  }
}

class TicketNotifier extends StateNotifier<TicketState> {
  final TicketRepository _repository;
  final CheckRepository _checkRepository;

  TicketNotifier(this._repository, this._checkRepository) : super(TicketState());

  Future<void> validateTicket(String ticketId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await _repository.validateTicket(ticketId);
      final ticket = TicketModel.fromJson(response);
      
      if (ticket.statusCode != 404) {
        final itemsResponse = await _repository.getTicketItems(ticketId);
        print('Items del ticket obtenidos:');
        print(itemsResponse);
        
        // Determinar el tipo de dispositivo
        String deviceType = 'otro';
        if (itemsResponse.items.isNotEmpty) {
          final firstItem = itemsResponse.items.first;
          deviceType = CheckModel.mapItemTypeToType(firstItem.itemtype);
        }
        
        final itemsMap = {
          'items': itemsResponse.items.map((item) => {
            'id': item.id,
            'itemtype': item.itemtype,
            'name': item.name,
          }).toList(),
          'total': itemsResponse.items.length,
        };
        
        state = state.copyWith(
          isLoading: false,
          ticketData: response,
          itemsData: itemsMap,
          deviceType: deviceType,  // Guardamos el tipo de dispositivo en el estado
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          ticketData: response,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  // Método para crear el check con el tipo de dispositivo almacenado
  Future<void> createCheck(String ticketId, {required int glpiID, required int createdBy}) async {
    try {
      if (state.deviceType == null) {
        throw Exception('Tipo de dispositivo no determinado');
      }

      // Mostrar los datos que se van a enviar
      debugPrint('==========================================');
      debugPrint('CREANDO CHECK - DATOS DE ENTRADA');
      debugPrint('==========================================');
      debugPrint('JSON de entrada: {');
      debugPrint('  "ticketId": "$ticketId",');
      debugPrint('  "type": "${state.deviceType}",');
      debugPrint('  "glpiID": $glpiID,');
      debugPrint('  "createdBy": $createdBy');
      debugPrint('}');
      debugPrint('==========================================');

      final check = await _checkRepository.createCheck(
        ticketId,
        type: state.deviceType!,
        glpiID: glpiID,
        createdBy: createdBy,
      );
      
      debugPrint('==========================================');
      debugPrint('CHECK CREADO EXITOSAMENTE');
      debugPrint('==========================================');
      debugPrint('Respuesta del servidor:');
      debugPrint(check.toString());
      debugPrint('==========================================');
    } catch (e) {
      debugPrint('==========================================');
      debugPrint('ERROR AL CREAR CHECK');
      debugPrint('==========================================');
      debugPrint('Error: ${e.toString()}');
      debugPrint('==========================================');
      
      state = state.copyWith(
        errorMessage: e.toString(),
      );
    }
  }
}

final ticketProvider = StateNotifierProvider<TicketNotifier, TicketState>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  final checkRepository = ref.watch(checkRepositoryProvider);
  return TicketNotifier(repository, checkRepository);
});