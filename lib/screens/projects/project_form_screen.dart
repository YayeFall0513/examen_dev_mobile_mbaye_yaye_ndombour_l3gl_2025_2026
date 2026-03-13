import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/Project.dart';
import '../../providers/project_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/cards/project_card.dart';

class ProjectFormScreen extends StatefulWidget {
  final String userId;
  final Project? project; // null = création, non-null = modification

  const ProjectFormScreen({super.key, required this.userId, this.project});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  // Couleurs prédéfinies
  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
  ];

  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?.description ?? '');
    _selectedColor = widget.project?.color ?? AppColors.primary;

    // Écouter les changements pour l'aperçu temps réel
    _nameController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context, listen: false);
    final isEditing = widget.project != null;

    // Créer une "prévisualisation" du projet pour ProjectCard
    final previewProject = Project(
      id: widget.project?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      userId: widget.userId,
      ownerId: widget.userId,
      color: _selectedColor ?? Colors.blue,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Modifier projet" : "Nouveau projet"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nom du projet
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom du projet"),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return "Nom obligatoire (min 3 caractères)";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),

              const SizedBox(height: 16),
              const Text("Couleur du projet"),
              const SizedBox(height: 8),

              // Sélecteur de couleur
              Wrap(
                spacing: 8,
                children: _colors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: isSelected ? 20 : 16,
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Aperçu temps réel avec ProjectCard
              ProjectCard(
                project: previewProject,
                taskCount: 0,
                onTap: () {},
                onMenuSelected: (_) {},
              ),

              const SizedBox(height: 24),

              // Bouton créer / modifier
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final project = Project(
                      id: widget.project?.id ?? const Uuid().v4(),
                      name: _nameController.text.trim(),
                      description: _descriptionController.text.trim(),
                      userId: widget.userId,
                      ownerId: widget.userId,
                      color: _selectedColor ?? Colors.blue,
                    );

                    if (isEditing) {
                      await projectProvider.updateProject(project);
                    } else {
                      await projectProvider.createProject(project);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(isEditing ? "Modifier" : "Créer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
