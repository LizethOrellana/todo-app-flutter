import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../../domain/entities/user.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../blocs/task_bloc.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  final _userRepo = UserRepositoryImpl();

  List<User> _users = [];
  User? _selectedUser;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? "",
    );

    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _userRepo.getUsers();

      if (!mounted) return;

      setState(() {
        _users = users;
        if (widget.task.userId != null && _users.isNotEmpty) {
          _selectedUser = _users.firstWhere(
            (u) => u.id == widget.task.userId,
            orElse: () => _users.first,
          );
        }
      });
    } catch (e) {
      debugPrint("Error cargando usuarios: $e");
    }
  }

  void _updateTask() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("El título es obligatorio")));
      return;
    }

    final updatedTask = Task(
      id: widget.task.id,
      title: title,
      description: _descriptionController.text.trim(),
      status: widget.task.status,
      projectId: widget.task.projectId,
      userId: _selectedUser?.id,
    );

    context.read<TaskBloc>().updateStatus(
      updatedTask,
      updatedTask.status,
      updatedTask.projectId,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Tarea"),
        backgroundColor: const Color(0xFF235347),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Título",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Responsable",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<User>(
              value: _selectedUser,
              hint: const Text("Seleccionar usuario"),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: _users.map((u) {
                return DropdownMenuItem(value: u, child: Text(u.name));
              }).toList(),
              onChanged: (u) => setState(() => _selectedUser = u),
            ),

            const SizedBox(height: 40),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _updateTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF235347),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "GUARDAR CAMBIOS",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
