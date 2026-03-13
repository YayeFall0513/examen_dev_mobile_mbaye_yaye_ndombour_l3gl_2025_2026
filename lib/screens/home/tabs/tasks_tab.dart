import 'package:flutter/material.dart';

class TasksTab extends StatelessWidget {
  final String userId;
  const TasksTab({super.key,required this.userId});

  @override
  Widget build(BuildContext context) {

    final List<String> tasks = [];

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.task_alt, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Aucune tâche disponible",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.check_box_outline_blank),
            title: Text(tasks[index]),
          ),
        );
      },
    );
  }
}