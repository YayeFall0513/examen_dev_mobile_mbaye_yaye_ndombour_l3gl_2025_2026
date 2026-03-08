import 'package:uuid/uuid.dart';

/// Statuts possibles d’une tâche
enum TaskStatus { todo, inProgress, done }

/// Priorités possibles d’une tâche
enum TaskPriority { low, medium, high }

class Task {
  final String id;           // Identifiant unique de la tâche
  final String projectId;    // ID du projet auquel elle appartient
  final String title;        // Titre de la tâche
  final String description;  // Description
  TaskStatus status;          // Statut (modifiable)
  TaskPriority priority;      // Priorité (modifiable)
  final DateTime createdAt;   // Date de création

  Task({
    String? id,
    required this.projectId,
    required this.title,
    required this.description,
    this.status = TaskStatus.todo,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Pour créer une copie avec quelques champs modifiés
  Task copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convertir en Map pour stockage / serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'title': title,
      'description': description,
      'status': status.name,
      'priority': priority.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Créer un objet Task depuis un Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      projectId: map['projectId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      status: TaskStatus.values.firstWhere(
              (e) => e.name == map['status'],
          orElse: () => TaskStatus.todo),
      priority: TaskPriority.values.firstWhere(
              (e) => e.name == map['priority'],
          orElse: () => TaskPriority.medium),
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, priority: $priority)';
  }
}