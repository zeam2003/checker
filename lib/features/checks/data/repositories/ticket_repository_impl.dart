import 'package:checker/features/checks/domain/models/ticket_item_model.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_datasource.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketDatasource datasource;
  final String token;

  TicketRepositoryImpl(this.datasource, this.token);

  @override
  Future<Map<String, dynamic>> validateTicket(String ticketId) {
    return datasource.validateTicket(ticketId, token);
  }

  @override
  Future<TicketItemModel> getTicketItems(String ticketId) async {
    final response = await datasource.getTicketItems(ticketId, token);
    return TicketItemModel.fromJson(response);
  }
}