import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ticket_provider.dart';

class TicketInputSection extends ConsumerWidget {
  final TextEditingController controller;
  final bool showTicketInput;
  final bool showResults;
  final VoidCallback onValidate;
  final VoidCallback onClose;

  const TicketInputSection({
    super.key,
    required this.controller,
    required this.showTicketInput,
    required this.showResults,
    required this.onValidate,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketState = ref.watch(ticketProvider);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¿Tienes un número de ticket?',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  color: Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (showTicketInput) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      enabled: !ticketState.isLoading && !showResults,
                      decoration: InputDecoration(
                        hintText: 'Ingrese el número de ticket',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.confirmation_number_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: (!ticketState.isLoading && !showResults) 
                      ? onValidate 
                      : null,
                    icon: ticketState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.check_circle_outline),
                    label: Text(
                      ticketState.isLoading ? 'Validando...' : 'Validar',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C4DFF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}