import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/ticket_model.dart';

class TicketInfo extends StatelessWidget {
  final Map<String, dynamic> ticketData;
  final VoidCallback onRetry;
  final VoidCallback onConfirm;

  const TicketInfo({
    super.key,
    required this.ticketData,
    required this.onRetry,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final ticket = TicketModel.fromJson(ticketData);
    final isClosed = ticket.status == 5 || ticket.status == 6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isClosed),
              const SizedBox(height: 16),
              _buildInfoRow('Ticket:', '#${ticket.id}'),
              _buildInfoRow('Título:', ticket.name),
              _buildInfoRow('Creado:', ticket.date),
              _buildInfoRow('Usuario:', ticket.userRecipient),
            ],
          ),
        ),
        _buildActions(isClosed),
      ],
    );
  }

  Widget _buildHeader(bool isClosed) {
    if (isClosed) {
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
    return Text(
      'Información del Ticket',
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildActions(bool isClosed) {
    return Column(
      children: [
        if (isClosed)
          _buildRetryButton()
        else ...[
          _buildConfirmButton(),
          const SizedBox(height: 12),
          _buildRetryButton(),
        ],
      ],
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton.icon(
      onPressed: onConfirm,
      icon: const Icon(Icons.check_circle),
      label: const Text('Confirmar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildRetryButton() {
    return ElevatedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.change_circle_outlined),
      label: const Text('Cambiar'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange.shade50,
        foregroundColor: Colors.orange.shade700,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
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
}