import 'package:checker/features/checks/domain/models/ticket_item_model.dart';

abstract class TicketRepository {
  Future<Map<String, dynamic>> validateTicket(String ticketId);
  Future<TicketItemModel> getTicketItems(String ticketId);
}

