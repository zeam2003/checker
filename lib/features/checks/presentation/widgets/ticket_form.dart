import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketForm extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final bool showResults;
  final VoidCallback onValidate;

  const TicketForm({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.showResults,
    required this.onValidate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            enabled: !isLoading && !showResults,
            onFieldSubmitted: (!isLoading && !showResults)
              ? (_) => onValidate()
              : null,
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
          onPressed: (!isLoading && !showResults) 
            ? onValidate 
            : null,
          icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
              ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7C4DFF),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          label: Text(
            isLoading ? 'Validando...' : 'Validar',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}