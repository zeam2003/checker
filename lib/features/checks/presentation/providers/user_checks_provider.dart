import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_checks.dart';
import '../../data/repositories/checks_repository.dart';
import '../../../auth/presentation/providers/user_session_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shared/providers/dio_provider.dart';  // Añadimos esta importación también

final userChecksProvider = FutureProvider<UserChecks>((ref) async {
  final userSession = ref.watch(userSessionProvider);
  final repository = ref.watch(checksRepositoryProvider);

  if (userSession == null) throw Exception('Usuario no autenticado');

  return repository.getUserChecks(userSession.userId, userSession.sessionToken);
});

final checksRepositoryProvider = Provider<ChecksRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ChecksRepository(dio);
});