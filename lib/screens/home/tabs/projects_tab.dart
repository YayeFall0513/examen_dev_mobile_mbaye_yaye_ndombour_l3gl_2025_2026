import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/Project.dart';
import '../../../providers/project_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../projects/project_detail_screen.dart';

class ProjectsTab extends StatelessWidget {
  final String userId;

  const ProjectsTab({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final List<Project> projects = projectProvider.projects;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Liste des projets",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // État vide
          if (projects.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.folder_open, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "Aucun projet disponible",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
          // Liste des projets
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(backgroundColor: project.color),
                      title: Text(project.name),
                      subtitle: Text(project.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProjectDetailScreen(project: project),
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