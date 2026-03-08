import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  // Propriétés privées
  bool _isOnboardingComplete = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  // Getters publics
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  // Méthodes à implémenter
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    // Lire depuis le stockage
    _isOnboardingComplete =
      StorageService.instance.isOnboardingComplete;

    _isInitialized = true;
    _isLoading = false;
    notifyListeners();
  }
  //Terminer l’onboarding
  Future<void> completeOnboarding() async {
    _isLoading = true;
    notifyListeners();

    _isOnboardingComplete = true;

    await StorageService.instance.setOnboardingComplete(true);
    _isLoading = false;
    notifyListeners();
  }

  // Réinitialiser l’onboarding
  Future<void> resetOnboarding() async {
    _isLoading = true;
    notifyListeners();

    _isOnboardingComplete = false;


    await StorageService.instance.setOnboardingComplete(false);

    _isLoading = false;
    notifyListeners();
  }
}