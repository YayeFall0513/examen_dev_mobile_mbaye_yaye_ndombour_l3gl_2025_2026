import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/Project.dart';
import '../../models/Task.dart';
import '../../providers/project_provider.dart';
import '../../providers/task_provider.dart';
import '../../core/constants/app_colors.dart';
import '../projects/project_form_screen.dart';
import '../tasks/task_detail_screen.dart';
import '../tasks/task_form_screen.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    // récupérer projet mis à jour
    final currentProject =
    projectProvider.projects.firstWhere((p) => p.id == project.id);

    final tasks = taskProvider.getTasksByProject(currentProject.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(currentProject.name),
        backgroundColor: currentProject.color,
        actions: [

          // Modifier projet
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectFormScreen(
                    project: currentProject,
                    userId: currentProject.ownerId,
                  ),
                ),
              );
            },
          ),

          // Supprimer projet
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {

              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Supprimer le projet"),
                  content: const Text(
                      "Voulez-vous vraiment supprimer ce projet ?"),
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

                // supprimer les tâches du projet
                final projectTasks =
                taskProvider.getTasksByProject(currentProject.id);

                for (var task in projectTasks) {
                  await taskProvider.deleteTask(task.id);
                }

                // supprimer projet
                await projectProvider.deleteProject(currentProject.id);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Projet supprimé")),
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
              currentProject.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(currentProject.description),

            const SizedBox(height: 20),

            const Text(
              "Tâches du projet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                child: Text("Aucune tâche dans ce projet"),
              )
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {

                  final task = tasks[index];

                  return Card(
                    child: ListTile(
                      title: Text(task.title),
                      subtitle:
                      Text("Statut : ${task.status.name}"),
                      onTap: () {
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: currentProject.color,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskFormScreen(
                projectId: currentProject.id,
              ),
            ),
          );
        },
      ),
    );
  }
}