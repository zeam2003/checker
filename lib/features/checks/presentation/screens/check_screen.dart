import 'package:checker/features/auth/presentation/providers/user_session_provider.dart';
import 'package:checker/features/checks/domain/models/ticket_model.dart';
import 'package:checker/features/checks/presentation/providers/check_provider.dart';
import 'package:checker/features/checks/presentation/widgets/check_header.dart';
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
  bool _showTicketInput = false;
  bool _showNewTicketForm = false;  // Initialize the variable here

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
    final checkState = ref.watch(checkProvider);

    return Column(
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
        if (!isClosed) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: checkState.isLoading 
              ? null 
              : () {
                  final ticketState = ref.read(ticketProvider);
                  final userSession = ref.read(userSessionProvider);
                  
                  if (userSession == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error: Usuario no autenticado'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  if (ticketState.deviceType == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error: Tipo de dispositivo no determinado'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  ref.read(checkProvider.notifier).createCheck(
                    ticket.id.toString(),
                    type: ticketState.deviceType!,
                    glpiID: userSession.userId,
                    createdBy: userSession.userId,
                  );
                },
            icon: checkState.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.play_arrow),
            label: Text(
              checkState.isLoading ? 'Creando check...' : 'Iniciar Chequeo'
            ),
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
          if (checkState.errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            checkState.errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Limpiamos el estado del check
                      ref.read(checkProvider.notifier).clearState();
                      // Llamamos al método handleRetry que ya tiene la lógica correcta
                      _handleRetry();
                    },
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
              ),
            ),
          ],
          if (checkState.checkData != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Check creado exitosamente',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
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

  Widget _buildTicketCard(TicketState ticketState) {
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
            if (!_showNewTicketForm) ...[
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
                    onPressed: () {
                      if (_showTicketInput) {
                        setState(() {
                          _showTicketInput = false;
                          _showResults = false;
                          _ticketController.clear();
                        });
                      } else {
                        context.go('/');
                      }
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!_showTicketInput)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showTicketInput = true;
                            });
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.black87,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB7E4C7), // Verde pastel más suave
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          label: const Text(
                            'Sí, tengo un ticket',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.go('/checks/${widget.checkType}/new');
                        },
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFF5C6BC0),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 2,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: Color(0xFF5C6BC0),
                              width: 1,
                            ),
                          ),
                        ),
                        label: const Text(
                          'No, creemos uno',
                          style: TextStyle(
                            color: Color(0xFF5C6BC0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  children: [
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
            ],
          ],
        ),
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
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckHeader(title: screenTitle),
                      _buildTicketCard(ticketState),
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