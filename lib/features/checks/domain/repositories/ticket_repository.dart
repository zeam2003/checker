abstract class TicketRepository {
  Future<Map<String, dynamic>> validateTicket(String ticketId);
}