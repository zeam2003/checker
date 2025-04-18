import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';  // Añadir esta línea

import 'package:checker/features/auth/presentation/providers/user_session_provider.dart';
import 'package:checker/features/auth/presentation/screens/login_screen.dart';

import '../providers/diagnostic_provider.dart';

class HomeScreen extends ConsumerWidget {  // Changed to ConsumerWidget
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Added WidgetRef
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/logo.png', height: 40),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Checker',
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Registro de Verificación y diagnóstico',
                            style: GoogleFonts.roboto(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  const _NavigationItem(title: 'Home', isSelected: true),
                  const SizedBox(width: 20),
                  const _NavigationItem(title: 'Inbox'),
                  const SizedBox(width: 20),
                  Stack(
                    children: [
                      const Icon(FontAwesomeIcons.bell),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            '99+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  PopupMenuButton<int>(
                    offset: const Offset(0, 40),
                    child: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 20,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Salir',
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 1) {
                        ref.read(userSessionProvider.notifier).logout();
                        context.go('/login');
                      }
                    },
                  ),
                ],
              ),
            ),
            
            // Info Bar
            Container(
              constraints: const BoxConstraints(maxWidth: 1600),
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _InfoItem(
                      title: 'Creado',
                      icon: Icons.calendar_today,
                      value: '07/04/2023',
                      iconColor: Colors.blue.shade700,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: _InfoItem(
                      title: 'Check',
                      icon: Icons.edit,
                      value: '1269',
                      iconColor: Colors.green.shade600,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: _InfoItem(
                      title: 'Ticket',
                      icon: Icons.receipt,
                      value: '30000',
                      iconColor: Colors.orange.shade700,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                  Expanded(
                    child: _InfoItem(
                      title: 'Usuario',
                      icon: Icons.person_outline,
                      value: 'Ejemplo de usuario',
                      iconColor: Colors.purple.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Progress Indicator
            Container(
              constraints: const BoxConstraints(maxWidth: 1600),
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Progreso de diagnóstico',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  const _StepProgressIndicator(),
                ],
              ),
            ),
            // Diagnostic Cards
            Container(
              margin: const EdgeInsets.all(20),
              child: const _DiagnosticCardList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _NavigationItem({
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: isSelected ? Colors.blue : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final Color? iconColor;

  const _InfoItem({
    required this.title,
    required this.icon,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepProgressIndicator extends ConsumerWidget {
  const _StepProgressIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosticState = ref.watch(diagnosticProvider);
    final steps = diagnosticState.items;

    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: Colors.grey.shade300,
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final item = steps[stepIndex];
        final isCompleted = item.status != DiagnosticStatus.pending;

        return Column(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: isCompleted ? _getStatusColor(item.status) : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? _getStatusColor(item.status) : Colors.grey.shade400,
                  width: 2,
                ),
                boxShadow: isCompleted ? [
                  BoxShadow(
                    color: _getStatusColor(item.status).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Center(
                child: isCompleted
                    ? Icon(
                        _getStatusIcon(item.status),
                        color: Colors.white,
                        size: 18,
                      )
                    : Text(
                        '${stepIndex + 1}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                color: isCompleted ? Colors.black : Colors.grey.shade600,
              ),
            ),
          ],
        );
      }),
    );
  }

  Color _getStatusColor(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.good:
        return Colors.green;
      case DiagnosticStatus.regular:
        return Colors.orange;
      case DiagnosticStatus.bad:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.good:
        return Icons.check;
      case DiagnosticStatus.regular:
        return Icons.warning;
      case DiagnosticStatus.bad:
        return Icons.close;
      default:
        return Icons.circle;
    }
  }
}

class _DiagnosticCardList extends ConsumerWidget {
  const _DiagnosticCardList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosticState = ref.watch(diagnosticProvider);

    final sortedItems = [...diagnosticState.items];
    sortedItems.sort((a, b) {
      if (a.status == DiagnosticStatus.pending && b.status != DiagnosticStatus.pending) {
        return -1;
      }
      if (a.status != DiagnosticStatus.pending && b.status == DiagnosticStatus.pending) {
        return 1;
      }
      return 0;
    });

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: sortedItems.map((item) {
        return _DiagnosticCard(
          key: ValueKey('card_${item.id}'),
          id: item.id,
          title: item.title,
          icon: _getIconForTitle(item.title),
          description: item.description,
        );
      }).toList(),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Pantalla':
        return Icons.laptop;
      case 'Teclado':
        return Icons.keyboard;
      case 'Touchpad':
        return Icons.touch_app;
      case 'WiFi':
        return Icons.wifi;
      case 'Ethernet':
        return Icons.lan;
      case 'Batería':
        return Icons.battery_full;
      case 'Detalles físicos':
        return Icons.build;
      case 'Funcionamiento general':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
}

class _DiagnosticCard extends ConsumerWidget {
  final String id;
  final String title;
  final IconData icon;
  final String description;

  const _DiagnosticCard({
    super.key,  // Añadimos el parámetro key
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnosticState = ref.watch(diagnosticProvider);
    final item = diagnosticState.items.firstWhere((item) => item.id == id);
    final hasStatus = item.status != DiagnosticStatus.pending;

    return Stack(
      children: [
        Container(
          width: 300,
          height: 220, // Reducida la altura
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Ajustado el padding vertical
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6), // Reducido el espaciado
              Text(
                description,
                style: const TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8), // Reducido el espaciado
              Row(
                children: [
                  _StatusButton(
                    label: 'Bueno',
                    color: Colors.green,
                    isSelected: item.status == DiagnosticStatus.good,
                    onTap: () => ref.read(diagnosticProvider.notifier)
                        .updateStatus(id, DiagnosticStatus.good),
                  ),
                  const SizedBox(width: 10),
                  // En la clase _DiagnosticCard, actualizar los botones:
                                    _StatusButton(
                                      label: 'Regular',
                                      color: Colors.orange,
                                      isSelected: item.status == DiagnosticStatus.regular,
                                      onTap: () => ref.read(diagnosticProvider.notifier)
                                          .updateStatus(id, DiagnosticStatus.regular),
                                    ),
                                    const SizedBox(width: 10),
                                    _StatusButton(
                                      label: 'Malo',
                                      color: Colors.red,
                                      isSelected: item.status == DiagnosticStatus.bad,
                                      onTap: () => ref.read(diagnosticProvider.notifier)
                                          .updateStatus(id, DiagnosticStatus.bad),
                                    ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Agregar observación...',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Ajustado el padding interno
                ),
                maxLines: 2,
                onChanged: (value) => ref.read(diagnosticProvider.notifier)
                    .updateObservation(id, value),
              ),
            ],
          ),
        ),
        if (hasStatus)
          Positioned.fill(
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, double value, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7 * value),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    opacity: value,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(diagnosticProvider.notifier).resetStatus(id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        child: const Text('Modificar'),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isSelected;

  const _StatusButton({
    required this.label,
    required this.color,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}