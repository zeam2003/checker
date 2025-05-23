import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'package:formz/formz.dart';
import '../../../shared/services/key_value_storage_service.dart';
import '../providers/user_session_provider.dart';
import '../../domain/models/user_session.dart';  // Corregida la ruta de importación
import '../../../shared/providers/dio_provider.dart';


// Eliminar esta línea ya que ahora está en dio_provider.dart
// final dioProvider = Provider((ref) => Dio());

final authRepositoryProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  final datasource = AuthDatasource(dio);
  return AuthRepositoryImpl(datasource);
});



// Estado del login
class LoginState {
  final bool isLoading;
  final bool isValid;
  final String? errorMessage;
  final String username;
  final String password;

  LoginState({
    this.isLoading = false,
    this.isValid = false,
    this.errorMessage,
    this.username = '',
    this.password = '',
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isValid,
    String? errorMessage,
    String? username,
    String? password,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}



// Notifier


// Añadir el provider para el servicio de storage
final keyValueStorageProvider = Provider((ref) => KeyValueStorageService());

class LoginFormNotifier extends StateNotifier<LoginState> {
  final AuthRepositoryImpl repository;
  final KeyValueStorageService keyValueStorage;
  final Ref ref;  // Añadido Ref
  
  LoginFormNotifier(this.repository, this.keyValueStorage, this.ref) : super(LoginState());  // Actualizado constructor

  void onUsernameChange(String value) {
    state = state.copyWith(
      username: value,
      isValid: value.isNotEmpty && state.password.isNotEmpty,
    );
  }

  void onPasswordChange(String value) {
    state = state.copyWith(
      password: value,
      isValid: value.isNotEmpty && state.username.isNotEmpty,
    );
  }

  Future<void> onSubmit(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final loginResponse = await repository.login(state.username, state.password);
      
      if (!context.mounted) return;
      
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Crear la sesión del usuario y guardarla (esto ya maneja la persistencia internamente)
      final userSession = UserSession.fromJson(loginResponse);
      ref.read(userSessionProvider.notifier).login(userSession);
      
      context.go('/');
      
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }
}

// Actualizar el provider para pasar ref
final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final keyValueStorage = ref.watch(keyValueStorageProvider);
  return LoginFormNotifier(repository, keyValueStorage, ref);  // Pasando ref
});