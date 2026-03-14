import 'package:flutter/foundation.dart';
import '../models/Project.dart';
import '../models/Task.dart';
import '../services/storage_service.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];
  Project? _selectedProject;
  bool _isLoading = false;

  //===== Getters =====
  List<Project> get projects => _projects;
  Project? get selectedProject => _selectedProject;
  int get projectCount => _projects.length;
  bool get isLoading => _isLoading;

  //===== Méthodes =====
  Future<void> loadProjects(String userId) async {
    _isLoading = true;
    notifyListeners();

    await StorageService.instance.init();
    final projectsMap = StorageService.instance.getSavedUser(); // Pour simplifier, remplacer par storage de projets réel

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createProject(Project project) async {
    _projects.add(project);
    notifyListeners();
    // Sauvegarde éventuelle dans le StorageService
  }

  Future<void> updateProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((p) => p.id == projectId);
    if (_selectedProject?.id == projectId) {
      _selectedProject = null;
    }
    notifyListeners();
  }

  void selectProject(Project? project) {
    _selectedProject = project;
    notifyListeners();
  }
}