import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Task.dart';
import '../../providers/task_provider.dart';
import '../../core/constants/app_colors.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // récupérer la tâche mise à jour depuis le provider
    final currentTask =
    taskProvider.allTasks.firstWhere((t) => t.id == task.id);

    Future<void> changeStatus(TaskStatus status) async {
      final updatedTask = currentTask.copyWith(status: status);
      await taskProvider.updateTask(updatedTask);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de la tâche"),
        backgroundColor: AppColors.primary,
        actions: [

          // Modifier tâche
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TaskFormScreen(
                    task: currentTask,
                    projectId: currentTask.projectId,
                  ),
                ),
              );
            },
          ),

          // Supprimer tâche
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {

              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Supprimer la tâche"),
                  content: const Text(
                      "Voulez-vous vraiment supprimer cette tâche ?"),
                  actions: [
                    TextButton(
                      child: const Text("Annuler"),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    ElevatedButton(
                      child: const Text("Supprimer"),
                      onPressed: () => Navigator.pop(context, true),
                    )
                  ],
                ),
              );

              if (confirm == true) {
                await taskProvider.deleteTask(currentTask.id);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tâche supprimée")),
                );
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              currentTask.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(currentTask.description),

            const SizedBox(height: 20),

            const Text(
              "Statut",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [

                ChoiceChip(
                  label: const Text("À faire"),
                  selected: currentTask.status == TaskStatus.todo,
                  onSelected: (_) => changeStatus(TaskStatus.todo),
                ),

                const SizedBox(width: 10),

                ChoiceChip(
                  label: const Text("En cours"),
                  selected: currentTask.status == TaskStatus.inProgress,
                  onSelected: (_) => changeStatus(TaskStatus.inProgress),
                ),

                const SizedBox(width: 10),

                ChoiceChip(
                  label: const Text("Terminé"),
                  selected: currentTask.status == TaskStatus.done,
                  onSelected: (_) => changeStatus(TaskStatus.done),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              "Priorité : ${currentTask.priority.name}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}