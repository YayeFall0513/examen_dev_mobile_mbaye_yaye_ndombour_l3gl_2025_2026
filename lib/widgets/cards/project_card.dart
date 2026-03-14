import 'package:flutter/material.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import 'package:sunu_task/models/Project.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final int taskCount;
  final VoidCallback? onTap;
  final Function(String)? onMenuSelected;

  const ProjectCard({
    super.key,
    required this.project,
    required this.taskCount,
    this.onTap,
    this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Pastille couleur
              CircleAvatar(
                radius: 6,
                backgroundColor: AppColors.primary,
              ),
              const SizedBox(width: 12),
              // Info projet
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      project.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$taskCount tâches",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textDisable,
                      ),
                    ),
                  ],
                ),
              ),
              // Menu contextuel
              PopupMenuButton<String>(
                onSelected: onMenuSelected,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Modifier'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Supprimer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}