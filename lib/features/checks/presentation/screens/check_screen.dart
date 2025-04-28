import 'package:checker/features/checks/domain/models/ticket_model.dart';
import 'package:checker/features/landing/presentation/widgets/landing_header.dart';
import 'package:checker/features/shared/widgets/custom_breadcrumb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/ticket_provider.dart';

class CheckScreen extends ConsumerStatefulWidget {
  final String checkType;

  const CheckScreen({
    super.key,
    required this.checkType,
  });

  @override
  ConsumerState<CheckScreen> createState() => CheckScreenState();
}

class CheckScreenState extends ConsumerState<CheckScreen> {
  final _ticketController = TextEditingController();
  bool _showResults = false;

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
      isActive: true
    ),
  ];

  void _handleValidation() {
    if (_ticketController.text.isNotEmpty) {
      print('Validando ticket: ${_ticketController.text}');
      ref.read(ticketProvider.notifier).validateTicket(_ticketController.text);
      setState(() {
        _showResults = true;
      });
    }
  }

  void _handleRetry() {
    setState(() {
      _showResults = false;
    });
    _ticketController.clear();
  }

  Widget _buildTicketResults(TicketState ticketState) {
    if (!_showResults) return const SizedBox.shrink();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (ticketState.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (ticketState.ticketData != null && ticketState.ticketData!['statusCode'] == 404)
                _buildErrorState()
              else if (ticketState.ticketData != null)
                _buildTicketData(ticketState.ticketData!)
              else if (ticketState.errorMessage != null)
                _buildErrorState()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketDataWithValidation(Map<String, dynamic> ticketData) {
    final ticket = TicketModel.fromJson(ticketData);
    
    if (!ticket.isValid) {
      return _buildErrorState();
    }
    
    return _buildTicketData(ticketData);
  }

  Widget _buildErrorState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700, size: 24),
            const SizedBox(width: 12),
            Text(
              'El ticket no existe',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _handleRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Reintentar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketData(Map<String, dynamic> ticketData) {
    final ticket = TicketModel.fromJson(ticketData);
    final isClosed = ticket.status == 5 || ticket.status == 6;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,  // Cambiado a center
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isClosed) ...[
                Row(
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
                ),
              ] else ...[
                Text(
                  'Información del Ticket',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _buildInfoRow('Ticket:', '#${ticket.id}'),
              _buildInfoRow('Título:', ticket.name),
              _buildInfoRow('Creado:', ticket.date),
              _buildInfoRow('Usuario:', ticket.userRecipient),
            ],
          ),
        ),
        Column(
          children: [
            if (isClosed)
              ElevatedButton.icon(
                onPressed: _handleRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade50,
                  foregroundColor: Colors.orange.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              )
            else ...[
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implementar lógica de confirmación
                },
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
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _handleRetry,
                icon: const Icon(Icons.change_circle_outlined),
                label: const Text('Cambiar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade50,  // Cambiado a naranja claro
                  foregroundColor: Colors.orange.shade700, // Cambiado a naranja oscuro
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    final ticketState = ref.watch(ticketProvider);
    
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
                  constraints: const BoxConstraints(maxWidth: 800), // Cambiado de 1200 a 800
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.checklist_rounded,
                                  size: 32,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  screenTitle,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 48),
                              child: Text(
                                'Luego de este paso tu progreso quedará guardado automáticamente',
                                style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
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
                              Text(
                                '¿Tienes un número de ticket?',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _ticketController,
                                      enabled: !ticketState.isLoading && !_showResults,
                                      onFieldSubmitted: (!ticketState.isLoading && !_showResults)
                                        ? (_) => _handleValidation()
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
                                    onPressed: (!ticketState.isLoading && !_showResults) 
                                      ? _handleValidation 
                                      : null,
                                    icon: ticketState.isLoading
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
                                      ticketState.isLoading ? 'Validando...' : 'Validar',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              _buildTicketResults(ticketState),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
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