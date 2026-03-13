import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/Project.dart';
import '../../models/Task.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/cards/task_card.dart';
import '../../core/constants/app_colors.dart';
import '../tasks/task_form_screen.dart';
import '../tasks/task_detail_screen.dart';
import 'project_form_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final tasks = taskProvider.getTasksByProject(project.id);

    final todo = tasks.where((t) => t.status == TaskStatus.todo).length;
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final done = tasks.where((t) => t.status == TaskStatus.done).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        backgroundColor: project.color,
        actions: [
          // Modifier projet
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final authProvider =
              Provider.of(context, listen: false);
              final userId = authProvider.currentUser?.id;
              if (userId == null) return;

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectFormScreen(
                    project: project,
                    userId: userId,
                  ),
                ),
              );

              // Recharge les projets après modification
              if (userId != null) {
                await projectProvider.loadProjects(userId);
              }
            },
          ),

          // Supprimer projet
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmDelete(context, projectProvider, taskProvider),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: project.color,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskFormScreen(projectId: project.id),
            ),
          );
        },
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header projet
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: project.color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.name,
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(project.description,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 10),
                Text(
                  "Créé le : ${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year} ${project.createdAt.hour}:${project.createdAt.minute.toString().padLeft(2,'0')}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Statistiques
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text("À faire : $todo")),
              Chip(label: Text("En cours : $inProgress")),
              Chip(label: Text("Terminé : $done")),
            ],
          ),

          const SizedBox(height: 10),

          // Liste des tâches
          Expanded(
            child: tasks.isEmpty
                ? const Center(child: Text("Aucune tâche pour ce projet"))
                : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaskDetailScreen(task: task),
                      ),
                    );
                  },
                  child: TaskCard(task: task),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProjectProvider projectProvider,
      TaskProvider taskProvider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer le projet"),
        content: const Text(
            "Voulez-vous vraiment supprimer ce projet et toutes ses tâches ?"),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Supprimer"),
            onPressed: () async {
              // Supprime toutes les tâches
              final tasksToRemove =
              taskProvider.getTasksByProject(project.id);
              for (var t in tasksToRemove) {
                await taskProvider.deleteTask(t.id);
              }

              // Supprime le projet
              await projectProvider.deleteProject(project.id);

              Navigator.pop(context); // fermer dialog
              Navigator.pop(context); // revenir à l'écran précédent
            },
          ),
        ],
      ),
    );
  }
}