import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/Project.dart';
import '../../../providers/project_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../projects/project_form_screen.dart';
import '../../projects/project_detail_screen.dart';
import '../../../widgets/cards/project_card.dart';

class ProjectsTab extends StatelessWidget {
  final String userId;
  const ProjectsTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {

    return Consumer<ProjectProvider>(
      builder: (context, projectProvider, child) {

        // Filtrer les projets de l'utilisateur
        final userProjects = projectProvider.projects
            .where((p) => p.userId == userId)
            .toList();

        if (userProjects.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.folder_open, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Aucun projet pour le moment",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: userProjects.length,
          itemBuilder: (context, index) {
            final project = userProjects[index];
            return ProjectCard(
              project: project,
              taskCount: 0, // plus tard: compter les tâches via TaskProvider
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProjectDetailScreen(project: project),
                  ),
                );
              },
              onMenuSelected: (value) async {
                if (value == 'edit') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectFormScreen(project: project, userId: '',),
                    ),
                  );
                } else if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(

                      title: const Text("Supprimer projet"),
                      content: const Text("Voulez-vous vraiment supprimer ce projet ?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Annuler"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Supprimer"),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await projectProvider.deleteProject(project.id);
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}