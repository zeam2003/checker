import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:checker/features/checks/presentation/widgets/check_header.dart';
import 'package:checker/features/landing/presentation/widgets/landing_header.dart';
import 'package:checker/features/shared/widgets/custom_breadcrumb.dart';

class NewTicketScreen extends ConsumerStatefulWidget {
  final String checkType;

  const NewTicketScreen({
    super.key,
    required this.checkType,
  });

  @override
  ConsumerState<NewTicketScreen> createState() => NewTicketScreenState();
}

class NewTicketScreenState extends ConsumerState<NewTicketScreen> {
  final _titleController = TextEditingController();
  String? _selectedAsset;

  String get screenTitle {
    switch (widget.checkType) {
      case 'complete':
        return 'Chequeo Completo';
      case 'quick':
        return 'Chequeo Rápido';
      default:
        return 'Chequeo';
    }
  }

  List<BreadcrumbItem> get _breadcrumbItems => [
    const BreadcrumbItem(label: 'Inicio'),
    BreadcrumbItem(label: 'Chequeos'),
    BreadcrumbItem(
      label: widget.checkType == 'complete' ? 'Completo' : 'Rápido',
    ),
    const BreadcrumbItem(
      label: 'Nuevo Ticket',
      isActive: true,
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: LandingHeader(),
      ),
      body: Column(
        children: [
          CustomBreadcrumb(items: _breadcrumbItems),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckHeader(title: screenTitle),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Creando un nuevo Check + Ticket',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => context.go('/check/${widget.checkType}'),
                                    icon: const Icon(Icons.close),
                                    color: Colors.grey[600],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Título',
                                  hintText: 'Ingrese el título del ticket',
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.title_outlined),
                                ),
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedAsset,
                                decoration: InputDecoration(
                                  labelText: 'Activo',
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                  prefixIcon: const Icon(Icons.computer_outlined),
                                ),
                                hint: const Text('Seleccione un activo'),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'laptop',
                                    child: Text('Laptop'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'desktop',
                                    child: Text('Desktop'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'monitor',
                                    child: Text('Monitor'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'other',
                                    child: Text('Otro'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAsset = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () => context.go('/check/${widget.checkType}'),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Cancelar'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey[700],
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // TODO: Implementar lógica de creación
                                    },
                                    icon: const Icon(Icons.add_circle_outline),
                                    label: const Text('Crear Ticket'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF7C4DFF),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}