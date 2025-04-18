import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DiagnosticStatus { pending, good, regular, bad }

class DiagnosticItem {
  final String id;
  final String title;
  final String description;
  final DiagnosticStatus status;
  final String observation;
  final bool isCompleted;

  DiagnosticItem({
    required this.id,
    required this.title,
    required this.description,
    this.status = DiagnosticStatus.pending,
    this.observation = '',
    this.isCompleted = false,
  });

  DiagnosticItem copyWith({
    DiagnosticStatus? status,
    String? observation,
    bool? isCompleted,
  }) {
    return DiagnosticItem(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
      observation: observation ?? this.observation,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class DiagnosticState {
  final List<DiagnosticItem> items;
  final bool isCompleted;
  final String? animatingCardId; // Para controlar qué card está animando

  DiagnosticState({
    required this.items,
    this.isCompleted = false,
    this.animatingCardId,
  });
}

class DiagnosticNotifier extends StateNotifier<DiagnosticState> {
  DiagnosticNotifier() : super(DiagnosticState(items: _initialItems));

  static final List<DiagnosticItem> _initialItems = [
    DiagnosticItem(
      id: '1',
      title: 'Pantalla',
      description: 'Verificar estado físico y funcionamiento de la pantalla',
    ),
    DiagnosticItem(
      id: '2',
      title: 'Teclado',
      description: 'Comprobar todas las teclas y su respuesta',
    ),
    DiagnosticItem(
      id: '3',
      title: 'Touchpad',
      description: 'Evaluar sensibilidad y funcionamiento del touchpad',
    ),
    DiagnosticItem(
      id: '4',
      title: 'WiFi',
      description: 'Verificar conectividad y velocidad WiFi',
    ),
    DiagnosticItem(
      id: '5',
      title: 'Ethernet',
      description: 'Comprobar conexión de red por cable',
    ),
    DiagnosticItem(
      id: '6',
      title: 'Batería',
      description: 'Evaluar capacidad y duración de la batería',
    ),
    DiagnosticItem(
      id: '7',
      title: 'Detalles físicos',
      description: 'Revisar estado general del equipo',
    ),
    DiagnosticItem(
      id: '8',
      title: 'Funcionamiento general',
      description: 'Evaluación general del rendimiento',
    ),
  ];

  Future<void> updateStatus(String id, DiagnosticStatus status) async {
    // Primero actualizamos el estado
    state = DiagnosticState(
      items: state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(
            status: status,
            isCompleted: true,
          );
        }
        return item;
      }).toList(),
      isCompleted: _checkIfCompleted(),
      animatingCardId: id,
    );

    // Esperamos a que termine la animación del modal
    await Future.delayed(const Duration(milliseconds: 600)); // Ajustado para sincronizar

    // Iniciamos la animación de movimiento
    moveToEnd(id);
  }

  void moveToEnd(String id) {
    final items = [...state.items];
    final index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      final item = items.removeAt(index);
      items.add(item);
      state = DiagnosticState(
        items: items,
        isCompleted: state.isCompleted,
        animatingCardId: null, // Reseteamos el ID de animación
      );
    }
  }

  void resetStatus(String id) {
    state = DiagnosticState(
      items: state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(
            status: DiagnosticStatus.pending,
            isCompleted: false,
          );
        }
        return item;
      }).toList(),
      isCompleted: _checkIfCompleted(),
    );
  }

 

  void updateObservation(String id, String observation) {
    state = DiagnosticState(
      items: state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(observation: observation);
        }
        return item;
      }).toList(),
      isCompleted: state.isCompleted,
    );
  }

  bool _checkIfCompleted() {
    return state.items.every((item) => item.isCompleted);
  }
}

final diagnosticProvider =
    StateNotifierProvider<DiagnosticNotifier, DiagnosticState>((ref) {
  return DiagnosticNotifier();
});