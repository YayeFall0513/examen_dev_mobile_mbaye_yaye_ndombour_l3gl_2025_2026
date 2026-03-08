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

  // ===== Onboarding =====
  bool get isOnboardingComplete {
    return _prefs.getBool(_keyOnboardingComplete) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_keyOnboardingComplete, value);
  }

  // ===== USER =====

  /// Sauvegarder l'utilisateur
  Future<void> saveUser(Map<String, dynamic> user) async {
    String userJson = jsonEncode(user);
    await _prefs.setString(_keyCurrentUser, userJson);
  }

  /// Recuperer utilisateur
  Map<String, dynamic>? getUser() {
    String? userJson = _prefs.getString(_keyCurrentUser);

    if (userJson == null) return null;

    return jsonDecode(userJson);
  }

  /// Définir l'utilisateur courant
  Future<void> setCurrentUser(Map<String, dynamic> user) async {
    await saveUser(user);
  }

  /// Supprimer utilisateur (logout)
  Future<void> removeUser() async {
    await _prefs.remove(_keyCurrentUser);
  }

  /// Vérifier si connecté
  bool get isLoggedIn {
    return _prefs.containsKey(_keyCurrentUser);
  }

  /// Logout complet
  Future<void> clearSession() async {
    await _prefs.remove(_keyCurrentUser);
  }
}