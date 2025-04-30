import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/ticket_model.dart';

class TicketResultsSection extends StatelessWidget {
  final Map<String, dynamic>? ticketData;
  final VoidCallback onRetry;

  const TicketResultsSection({
    super.key,
    required this.ticketData,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (ticketData == null) return const SizedBox.shrink();
    
    final ticket = TicketModel.fromJson(ticketData!);
    final isClosed = ticket.status == 5 || ticket.status == 6;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isClosed) ...[
              _buildWarningHeader(),
            ] else ...[
              _buildNormalHeader(),
            ],
            const SizedBox(height: 16),
            _buildInfoRow('Ticket:', '#${ticket.id}'),
            _buildInfoRow('Título:', ticket.name),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningHeader() {
    return Row(
      children: [
        Icon(Icons.warning_amber_rounded, 
          color: Colors.orange.shade700, 
          size: 24
        ),
        const SizedBox(width: 12),
        Text(
          'El ticket está cerrado',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.orange.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildNormalHeader() {
    return Text(
      'Información del Ticket',
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}