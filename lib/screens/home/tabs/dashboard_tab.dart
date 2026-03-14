import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';
import '../../projects/project_detail_screen.dart';
import '/../../models/Task.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "Bonjour";
    if (hour >= 12 && hour < 18) return "Bon après-midi";
    return "Bonsoir";
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation de Consumer pour écouter les changements
    return Consumer2<ProjectProvider, TaskProvider>(
      builder: (context, projectProvider, taskProvider, child) {
        final projects = projectProvider.projects;
        final tasks = taskProvider.allTasks;

        // Comptage par statut
        final taskCountByStatus = {
          TaskStatus.todo: tasks.where((t) => t.status == TaskStatus.todo).length,
          TaskStatus.inProgress: tasks.where((t) => t.status == TaskStatus.inProgress).length,
          TaskStatus.done: tasks.where((t) => t.status == TaskStatus.done).length,
        };

        // Trier les projets par date de création décroissante
        final recentProjects = List.from(projects);
        recentProjects.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        final recent3 = recentProjects.length <= 3 ? recentProjects : recentProjects.sublist(0, 3);

        return RefreshIndicator(
          onRefresh: () async {
            await projectProvider.loadProjects('userId');
            await taskProvider.loadTasks();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Message de bienvenue
              Text(
                "${_getGreeting()} 👋",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Cartes statistiques
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard("Projets", projects.length.toString(), Icons.folder, AppColors.primary),
                  _buildStatCard("Todo", taskCountByStatus[TaskStatus.todo].toString(), Icons.pending, Colors.orange),
                  _buildStatCard("En cours", taskCountByStatus[TaskStatus.inProgress].toString(), Icons.autorenew, Colors.blue),
                  _buildStatCard("Done", taskCountByStatus[TaskStatus.done].toString(), Icons.check_circle, Colors.green),
                ],
              ),
              const SizedBox(height: 30),

              // Titre projets récents
              const Text(
                "Projets récents",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Liste projets récents
              Column(
                children: recentProjects.map((project) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProjectDetailScreen(project: project),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: project.color),
                        title: Text(project.name),
                        subtitle: Text(project.description),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProject(project) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: project.color ?? AppColors.primary),
        title: Text(project.name),
        subtitle: Text("Créé le : ${_formatDate(project.createdAt)}"),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Format : 13/03/2026 19:17
    return "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year} ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}";
  }
}
