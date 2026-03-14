import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import 'package:sunu_task/screens/home/tabs/dashboard_tab.dart';
import 'package:sunu_task/screens/home/tabs/projects_tab.dart';
import 'package:sunu_task/screens/home/tabs/tasks_tab.dart';
import 'package:sunu_task/screens/home/tabs/profile_tab.dart';
import '../../providers/auth_provider.dart';
import '../../screens/projects/project_form_screen.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    // Liste des onglets
    final List<Widget> _tabs = [
      const DashboardTab(),
      if (user != null)
        ProjectsTab(userId: user.id)
      else
        const Center(child: Text("Utilisateur non connecté")),
      if (user != null)
        TasksTab(userId: user.id)
      else
        const Center(child: Text("Utilisateur non connecté")),
      const ProfileTab(),
    ];

    void _changeTab(int index) {
      setState(() {
        _currentIndex = index;
      });
      Navigator.pop(context); // ferme le drawer si ouvert
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sunu Task"),
        backgroundColor: AppColors.primary,
      ),

      // Drawer avec déconnexion
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? "Utilisateur déconnecté"),
              accountEmail: Text(user?.email ?? ""),
              currentAccountPicture: CircleAvatar(
                child: Text(user != null ? user.name[0].toUpperCase() : "?"),
              ),
              decoration: BoxDecoration(color: AppColors.primary),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () => _changeTab(0),
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text("Projets"),
              onTap: () => _changeTab(1),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Tâches"),
              onTap: () => _changeTab(2),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profil"),
              onTap: () => _changeTab(3),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Déconnexion"),
              onTap: () async {
                await authProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      // Corps
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),

      // BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        onTap: _changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Projets"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tâches"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),

      // FloatingActionButton pour créer un projet (visible uniquement sur Dashboard et Projets)
      floatingActionButton: Visibility(
        visible: _currentIndex == 0 || _currentIndex == 1,
        child: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () {
            if (user == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProjectFormScreen(userId: user.id),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}