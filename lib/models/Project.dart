import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String userId;
  final String ownerId;
  final Color? color;
  final DateTime createdAt;

  Project({
    String? id,
    required this.name,
    required this.description,
    required this.userId,
    required this.ownerId,
    required this.color,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Copier un projet avec modifications
  Project copyWith({
    String? name,
    String? description,
    String? userId,
    String? ownerId,
    Color? color,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      ownerId: ownerId ?? this.ownerId,
      color: color ?? this.color,
      createdAt: createdAt,
    );
  }

  /// Convertir en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'userId': userId,
      'ownerId': ownerId,
      'color': color,
      'createdAt': "${createdAt.day.toString().padLeft(2,'0')}/"
          "${createdAt.month.toString().padLeft(2,'0')}/"
          "${createdAt.year} "
          "${createdAt.hour.toString().padLeft(2,'0')}:"
          "${createdAt.minute.toString().padLeft(2,'0')}",
    };
  }

  /// Créer depuis Map
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      description: map['description'] ?? '',
      userId: map['userId'],
      ownerId: map['ownerId'] ?? '',
      color: Color(map['color']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, name: $name)';
  }
}