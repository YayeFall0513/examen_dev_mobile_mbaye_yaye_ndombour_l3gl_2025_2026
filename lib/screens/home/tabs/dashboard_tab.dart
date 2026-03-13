import 'package:flutter/material.dart';
import 'package:sunu_task/core/constants/app_colors.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Bonjour";
    } else if (hour >= 12 && hour < 18) {
      return "Bon après-midi";
    } else {
      return "Bonsoir";
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // ici on rafraichira les données plus tard avec les providers
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Message de bienvenue
          Text(
            "${_getGreeting()} 👋",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Cartes statistiques
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard("Projets", "0", Icons.folder, AppColors.primary),
              _buildStatCard("Todo", "0", Icons.pending, Colors.orange),
              _buildStatCard("Done", "0", Icons.check_circle, Colors.green),
            ],
          ),

          const SizedBox(height: 30),

          // Titre projets récents
          const Text(
            "Projets récents",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // Liste projets récents
          _buildRecentProject("Projet Mobile"),
          _buildRecentProject("Projet Web"),
          _buildRecentProject("Projet IA"),

        ],
      ),
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

              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(title),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProject(String name) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.folder),
        title: Text(name),
        subtitle: const Text("Projet récent"),
      ),
    );
  }
}