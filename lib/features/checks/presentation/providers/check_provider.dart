
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../domain/models/check_model.dart';
import '../../data/datasources/check_datasource.dart';
import '../../data/repositories/check_repository_impl.dart';
import '../../../shared/providers/dio_provider.dart';
import '../../../auth/presentation/providers/user_session_provider.dart';

class CheckState {
  final bool isLoading;
  final CheckModel? checkData;
  final String? errorMessage;

  CheckState({
    this.isLoading = false,
    this.checkData,
    this.errorMessage,
  });

  CheckState copyWith({
    bool? isLoading,
    CheckModel? checkData,
    String? errorMessage,
  }) {
    return CheckState(
      isLoading: isLoading ?? this.isLoading,
      checkData: checkData ?? this.checkData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class CheckNotifier extends StateNotifier<CheckState> {
  final CheckRepositoryImpl _repository;

  CheckNotifier(this._repository) : super(CheckState());

  Future<void> createCheck(
    String ticketId, {
    required String type,
    required int glpiID,
    required int createdBy,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final check = await _repository.createCheck(
        ticketId,
        type: type,
        glpiID: glpiID,
        createdBy: createdBy,
      );
      
      state = state.copyWith(
        isLoading: false,
        checkData: check,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void clearState() {
    state = CheckState();
  }
}

final checkRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final userSession = ref.watch(userSessionProvider);
  if (userSession == null) throw Exception('Usuario no autenticado');
  
  final datasource = CheckDatasource(dio);
  return CheckRepositoryImpl(datasource, userSession.sessionToken);
});

final checkProvider = StateNotifierProvider<CheckNotifier, CheckState>((ref) {
  final repository = ref.watch(checkRepositoryProvider);
  return CheckNotifier(repository);
});