import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'counter_item.dart';
import '../../../checks/presentation/providers/user_checks_provider.dart';

class ChecksSummary extends ConsumerWidget {
  const ChecksSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checksAsync = ref.watch(userChecksProvider);

    return Column(
      children: [
        Text(
          'Mis Chequeos',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: checksAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text(
                  'Error al cargar los chequeos',
                  style: GoogleFonts.roboto(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
              data: (checks) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        checks.totalChecks.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Totales\nAcumulados',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          height: 1.2,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.assessment_rounded,
                        size: 42,
                        color: Colors.blue.shade200,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  CounterItem(
                    label: 'Esta Semana',
                    count: checks.weeklyChecks.toString(),
                    icon: Icons.calendar_today,
                    bgColor: Colors.green.shade100,
                    textColor: Colors.green.shade700,
                  ),
                  const SizedBox(height: 15),
                  CounterItem(
                    label: 'Este Mes',
                    count: checks.monthlyChecks.toString(),
                    icon: Icons.date_range,
                    bgColor: Colors.orange.shade100,
                    textColor: Colors.orange.shade700,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}