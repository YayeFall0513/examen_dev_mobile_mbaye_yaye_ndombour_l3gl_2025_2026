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
    final taskProvider = context.read<TaskProvider>();

    Future<void> _changeStatus(TaskStatus status) async {
      await taskProvider.updateTaskStatus(task.id, status);
    }

    Future<void> _deleteTask() async {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Confirmer la suppression"),
          content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annuler")),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Supprimer")),
          ],
        ),
      );

      if (confirm == true) {
        await taskProvider.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tâche supprimée")),
        );
        Navigator.pop(context); // Retour à l'écran précédent
      }
    }

    Color _priorityColor(TaskPriority priority) {
      switch (priority) {
        case TaskPriority.high:
          return Colors.red;
        case TaskPriority.medium:
          return Colors.orange;
        case TaskPriority.low:
          return Colors.green;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail tâche"),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      TaskFormScreen(task: task, projectId: task.projectId),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre
            Text(
              task.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              task.description.isEmpty ? "Pas de description" : task.description,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Statut
            const Text("Statut :", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: TaskStatus.values.map((status) {
                final isSelected = task.status == status;
                return GestureDetector(
                  onTap: () => _changeStatus(status),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status.name.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Priorité
            Row(
              children: [
                const Text("Priorité : ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  task.priority.name.toUpperCase(),
                  style: TextStyle(
                    color: _priorityColor(task.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Date d'échéance
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                Text(
                  task.dueDate != null
                      ? "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}"
                      : "Pas de date d'échéance",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}