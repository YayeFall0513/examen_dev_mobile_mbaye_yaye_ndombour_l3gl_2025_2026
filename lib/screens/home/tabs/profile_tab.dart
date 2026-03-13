import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/project_provider.dart';
import '../../../providers/task_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    final projectProvider = Provider.of<ProjectProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    final projectCount = projectProvider.projects.length;
    final taskCount = taskProvider.allTasks.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              user != null ? user.name[0].toUpperCase() : "?",
              style: const TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user?.name ?? "Utilisateur déconnecté",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(user?.email ?? ""),
          const SizedBox(height: 20),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Date d'inscription"),
            subtitle: Text(
              user != null
                  ? "${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}"
                  : "-",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text("Projets"),
            trailing: Text("$projectCount"),
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text("Tâches"),
            trailing: Text("$taskCount"),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);

              await authProvider.logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("Déconnexion"),
          ),
        ],
      ),
    );
  }
}