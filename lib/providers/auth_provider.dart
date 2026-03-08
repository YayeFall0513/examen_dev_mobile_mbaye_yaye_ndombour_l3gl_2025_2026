import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/user.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  //===== Propriétés privées =====
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  //===== Getters publics =====
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //===== Méthodes =====
  Future<void> init() async {
    await StorageService.instance.init();
    final userMap = StorageService.instance.getUser();
    if (userMap != null) {
      _currentUser = User.fromMap(userMap);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await StorageService.instance.init();
    final userMap = StorageService.instance.getUser();

    if (userMap != null) {
      final user = User.fromMap(userMap);
      if (user.email == email && user.password == password) {
        _currentUser = user;
        await StorageService.instance.setCurrentUser(user.toMap());
        _isLoading = false;
        notifyListeners();
        return true;
      }
    }

    _error = "Email ou mot de passe incorrect";
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await StorageService.instance.init();
    final existingUserMap = StorageService.instance.getUser();

    if (existingUserMap != null) {
      final existingUser = User.fromMap(existingUserMap);
      if (existingUser.email == email) {
        _error = "Un utilisateur avec cet email existe déjà";
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    final newUser = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      password: password,
    );

    await StorageService.instance.saveUser(newUser.toMap());
    _currentUser = newUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await StorageService.instance.removeUser();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? email}) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(
      name: name,
      email: email,
    );

    _currentUser = updatedUser;
    await StorageService.instance.setCurrentUser(updatedUser.toMap());
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}