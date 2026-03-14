import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sunu_task/core/constants/app_colors.dart';
import 'package:sunu_task/models/Task.dart';
import 'package:sunu_task/providers/task_provider.dart';
import 'package:uuid/uuid.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  final String projectId;

  const TaskFormScreen({super.key, this.task, required this.projectId});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  TaskStatus _status = TaskStatus.todo;
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _status = widget.task?.status ?? TaskStatus.todo;
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _dueDate = widget.task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider =
      Provider.of<TaskProvider>(context, listen: false);

      final newTask = Task(
        id: widget.task?.id ?? const Uuid().v4(),
        projectId: widget.projectId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _status,
        priority: _priority,
        dueDate: _dueDate, ownerId: 'user.id',
      );

      if (widget.task == null) {
        // Création
        await taskProvider.createTask(newTask);
      } else {
        // Modification
        await taskProvider.updateTask(newTask);
      }
     /** ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing
              ? "Tâche modifiée"
              : "Tâche créée"),
        ),
      );*/
      Navigator.pop(context);
    }
  }

  void _deleteTask() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmer la suppression"),
        content: const Text("Voulez-vous vraiment supprimer cette tâche ?"),
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
      final taskProvider =
      Provider.of<TaskProvider>(context, listen: false);
      await taskProvider.deleteTask(widget.task!.id);

      Navigator.pop(context);
    }
  }

  Widget _buildStatusSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: TaskStatus.values.map((s) {
        return ChoiceChip(
          label: Text(s.name),
          selected: _status == s,
          onSelected: (_) => setState(() => _status = s),
          selectedColor: AppColors.primary.withOpacity(0.3),
        );
      }).toList(),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: TaskPriority.values.map((p) {
        return ChoiceChip(
          label: Text(p.name),
          selected: _priority == p,
          onSelected: (_) => setState(() => _priority = p),
          selectedColor: AppColors.warningLight.withOpacity(0.3),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier la tâche" : "Nouvelle tâche"),
        backgroundColor: AppColors.primary,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTask,
            ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Titre
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Titre"),
                validator: (v) =>
                v == null || v.trim().isEmpty ? "Titre requis" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Statut
              const Text("Statut"),
              _buildStatusSelector(),
              const SizedBox(height: 16),

              // Priorité
              const Text("Priorité"),
              _buildPrioritySelector(),
              const SizedBox(height: 16),

              // Date d’échéance
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_dueDate == null
                    ? "Sélectionner la date d'échéance"
                    : "Échéance : ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectDueDate,
              ),
              const SizedBox(height: 32),

              // Bouton sauvegarder
              ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isEditing ? "Modifier" : "Créer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}