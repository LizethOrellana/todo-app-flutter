import 'package:flutter/material.dart';
import '../../data/repositories/project_repository_impl.dart';
import '../../domain/entities/project.dart';

class AllProjectsPage extends StatefulWidget {
  const AllProjectsPage({super.key});

  @override
  State<AllProjectsPage> createState() => _AllProjectsPageState();
}

class _AllProjectsPageState extends State<AllProjectsPage> {
  final repo = ProjectRepositoryImpl();
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await repo.getProjects();
    setState(() => projects = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todos los Proyectos")),
      body: ListView.builder(
        itemCount: projects.length,
        itemBuilder: (_, i) {
          final p = projects[i];
          return ListTile(
            title: Text(p.name),
            leading: const Icon(Icons.folder),
          );
        },
      ),
    );
  }
}
