import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../blocs/task_bloc.dart';

class CreateTaskPage extends StatefulWidget {
  final int projectId;

  const CreateTaskPage({super.key, required this.projectId});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  final userRepo = UserRepositoryImpl();
  List<User> users = [];
  User? selected;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    users = await userRepo.getUsers();
    setState(() {});
  }

  void save() {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("El título es obligatorio")));
      return;
    }

    context.read<TaskBloc>().addTask(
      title,
      descController.text,
      widget.projectId,
      userId: selected?.id,
    );

    Navigator.pop(context);
  }

  void addUser() async {
    final name = TextEditingController();
    final email = TextEditingController();

    final user = await showDialog<User>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Nuevo Usuario"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newUser = await userRepo.addUser(name.text, email.text);
              Navigator.pop(context, newUser);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );

    if (user != null) {
      users.add(user);
      selected = user;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nueva Tarea")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<User>(
              value: selected,
              hint: const Text("Seleccionar usuario"),
              items: users.map((u) {
                return DropdownMenuItem(value: u, child: Text(u.name));
              }).toList(),
              onChanged: (u) => setState(() => selected = u),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addUser,
              child: const Text("Agregar Usuario"),
            ),

            const SizedBox(height: 30),

            ElevatedButton(onPressed: save, child: const Text("Crear Tarea")),
          ],
        ),
      ),
    );
  }
}
