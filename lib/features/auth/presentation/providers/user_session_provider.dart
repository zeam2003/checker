import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_session.dart';
import 'dart:convert';


final userSessionProvider = StateNotifierProvider<UserSessionNotifier, UserSession?>((ref) {
  return UserSessionNotifier();
});

class UserSessionNotifier extends StateNotifier<UserSession?> {
  UserSessionNotifier() : super(null) {
    _loadFromStorage();
  }

  static const _storageKey = 'user_session';
  
  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_storageKey);
    if (userData != null) {
      final userMap = jsonDecode(userData);
      state = UserSession.fromJson(userMap);
    }
  }

  Future<void> login(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(session.toJson()));
    state = session;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    state = null;
  }
}