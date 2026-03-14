import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/**
 * Pattern Singleton:
 * Pour avoir une seule instance
 */
class StorageService {
  //===== Singleton ==========
  /// Instance Unique (privee)
  static StorageService? _instance;

  /// Getter pour acceder a l'instance
  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  /// Constructeur prive
  StorageService._();

  //===== SharedPreferences ==========
  /**
   * SharedPreferences utilise des opérations asynchrones
   * car il lit/ecrtit sur le disque
   *
   * Le mot-cle await attend que l'operation se termine
   * La fonction doit etre marque async et retourner un Future
   * Les variables doivent être marqué par late
   */
  late SharedPreferences _prefs;

  /// Indicateur d'initialisation
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // ===== Clés =====
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyCurrentUser = 'current_user';

  //===== Onboarding =====
  bool get isOnboardingComplete => _prefs.getBool(_keyOnboardingComplete) ?? false;
  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_keyOnboardingComplete, value);
  }

  //===== User =====
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString('saved_user', jsonEncode(user)); // clé différente
  }

  Map<String, dynamic>? getSavedUser() {
    final json = _prefs.getString('saved_user');
    if (json == null) return null;
    return jsonDecode(json);
  }

  Future<void> setCurrentUser(Map<String, dynamic> user) async {
    await _prefs.setString(_keyCurrentUser, jsonEncode(user));
  }

  Map<String, dynamic>? getCurrentUser() {
    final json = _prefs.getString('current_user');
    if (json == null) return null;
    return jsonDecode(json);
  }
  Future<void> removeUser() async {
    await _prefs.remove(_keyCurrentUser);
  }

  bool get isLoggedIn => _prefs.containsKey(_keyCurrentUser);

  Future<void> clearSession() async {
    await _prefs.remove(_keyCurrentUser);
  }
}