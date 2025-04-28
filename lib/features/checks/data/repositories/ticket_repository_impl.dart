import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_datasource.dart';
import '../../../auth/presentation/providers/user_session_provider.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketDatasource datasource;
  final String token;

  TicketRepositoryImpl(this.datasource, this.token);

  @override
  Future<Map<String, dynamic>> validateTicket(String ticketId) {
    return datasource.validateTicket(ticketId, token);
  }
}