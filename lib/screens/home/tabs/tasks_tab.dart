import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/Task.dart';
import '../../../providers/task_provider.dart';
import '../../tasks/task_detail_screen.dart';

class TasksTab extends StatelessWidget {
  final String userId;

  const TasksTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = taskProvider.allTasks;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Liste des tâches",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // État vide
          if (tasks.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.task_alt, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Aucune tâche disponible",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
          // Liste des tâches
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.check_box_outline_blank),
                      title: Text(task.title),
                      subtitle: Text(
                        "Statut: ${task.status.name.toUpperCase()} - Priorité: ${task.priority.name.toUpperCase()}",
                      ),
                      onTap: () {
                        // Navigation vers TaskDetailScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TaskDetailScreen(task: task),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}