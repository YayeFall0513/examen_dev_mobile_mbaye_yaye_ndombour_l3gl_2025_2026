import 'package:uuid/uuid.dart';

class Project {
  final String id;       // Identifiant unique du projet
  final String name;     // Nom du projet
  final String description;
  final String userId;   // Utilisateur propriétaire du projet
  final String ownerId;
  final DateTime createdAt; // Date de création

  Project({
    String? id,
    required this.name,
    required this.userId,
    DateTime? createdAt, required this.ownerId, required this.description,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Pour mettre à jour un projet facilement
  Project copyWith({
    String? id,
    String? name,
    String? userId,
    DateTime? createdAt,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt, description: '', ownerId: '',
    );
  }

  // Convertir en Map pour sauvegarde / stockage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Créer un Project depuis une Map
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      userId: map['userId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String), description: '', ownerId: '',
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name, userId: $userId)';
  }
}