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

  TicketState({
    this.isLoading = false,
    this.errorMessage,
    this.ticketData,
  });

  TicketState copyWith({
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? ticketData,
  }) {
    return TicketState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      ticketData: ticketData ?? this.ticketData,
    );
  }
}

class TicketNotifier extends StateNotifier<TicketState> {
  final TicketRepositoryImpl repository;
  
  TicketNotifier(this.repository) : super(TicketState());

  Future<void> validateTicket(String ticketId) async {
    try {
      print('Iniciando validación de ticket: $ticketId');
      state = state.copyWith(isLoading: true, errorMessage: null);
      final response = await repository.validateTicket(ticketId);
      print('Respuesta del servidor: $response');
      state = state.copyWith(
        isLoading: false,
        ticketData: response,
      );
    } catch (e) {
      print('Error en la validación del ticket: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

final ticketProvider = StateNotifierProvider<TicketNotifier, TicketState>((ref) {
  final repository = ref.watch(ticketRepositoryProvider);
  return TicketNotifier(repository);
});