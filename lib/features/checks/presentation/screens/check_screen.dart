import 'package:checker/features/landing/presentation/widgets/landing_header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class CheckScreen extends StatelessWidget {
  final String checkType;

  const CheckScreen({
    super.key,
    required this.checkType,
  });

  String get screenTitle {
    switch (checkType) {
      case 'complete':
        return 'Revisión Completa';
      case 'refurbished':
        return 'Revisión y Refurbished';
      default:
        return 'Revisión';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),  // Cambiado a context.pop() para una navegación consistente
        ),
        title: const LandingHeader(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    screenTitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Aquí irá el contenido específico de cada tipo de revisión
              ],
            ),
          ),
        ),
      ),
    );
  }
}