import 'package:flutter/material.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/entities/project.dart';
import 'kanban_page.dart' as kanban;

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final repo = ProjectRepositoryImpl();
  late Future<List<Project>> projects;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  void loadProjects() {
    projects = repo.getProjects();
  }

  void createProject() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuevo Proyecto"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Nombre"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              await repo.addProject(controller.text);
              Navigator.pop(context);
              setState(() => loadProjects());
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Proyectos")),
      floatingActionButton: FloatingActionButton(
        onPressed: createProject,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Project>>(
        future: projects,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final p = data[i];

              return ListTile(
                title: Text(p.name),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => kanban.KanbanPage(
                        projectId: p.id,
                        projectName: p.name,
                      ),
                    ),
                  );

                  setState(() => loadProjects());
                },
              );
            },
          );
        },
      ),
    );
  }
}
