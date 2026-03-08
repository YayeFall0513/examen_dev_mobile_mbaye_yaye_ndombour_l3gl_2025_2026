import 'package:flutter/foundation.dart';
import '../models/Task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskStatus? _statusFilter;
  TaskPriority? _priorityFilter;
  bool _isLoading = false;

  //===== Getters =====
  bool get isLoading => _isLoading;

  List<Task> get tasks {
    var filtered = _tasks;

    if (_statusFilter != null) {
      filtered = filtered.where((t) => t.status == _statusFilter).toList();
    }

    if (_priorityFilter != null) {
      filtered = filtered.where((t) => t.priority == _priorityFilter).toList();
    }

    // Tri par statut puis priorité
    filtered.sort((a, b) {
      final statusOrder = {
        TaskStatus.inProgress: 0,
        TaskStatus.todo: 1,
        TaskStatus.done: 2,
      };
      final priorityOrder = {
        TaskPriority.high: 0,
        TaskPriority.medium: 1,
        TaskPriority.low: 2,
      };

      final statusCompare = statusOrder[a.status]! - statusOrder[b.status]!;
      if (statusCompare != 0) return statusCompare;

      return priorityOrder[a.priority]! - priorityOrder[b.priority]!;
    });

    return filtered;
  }

  Map<TaskStatus, int> get taskCountByStatus {
    final map = <TaskStatus, int>{};
    for (var status in TaskStatus.values) {
      map[status] = _tasks.where((t) => t.status == status).length;
    }
    return map;
  }

  //===== Méthodes CRUD =====
  Future<void> loadTasks(String projectId) async {
    _isLoading = true;
    notifyListeners();
    // Charger les tâches depuis le storage
    _tasks = []; // Assigner la liste réelle
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    final task = _tasks.firstWhere((t) => t.id == taskId, orElse: () => null as Task);
    if (task != null) {
      task.status = status;
      notifyListeners();
    }
  }

  //===== Filtres =====
  void setStatusFilter(TaskStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _priorityFilter = priority;
    notifyListeners();
  }

  void clearFilters() {
    _statusFilter = null;
    _priorityFilter = null;
    notifyListeners();
  }
}