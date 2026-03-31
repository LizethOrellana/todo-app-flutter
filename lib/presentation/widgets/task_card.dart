import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/task.dart';
import '../blocs/task_bloc.dart';
import '../pages/edit_task_page.dart'; // Asegúrate de crear esta página

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Draggable<Task>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: Container(width: 280, child: _card(context)),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _card(context)),
      child: _card(context),
    );
  }

  Widget _card(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Mostramos descripción y el ID del usuario asignado
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  task.userId != null
                      ? "Asignado: ${task.userId}"
                      : "Sin asignar",
                  style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
              ],
            ),
          ],
        ),
        // BOTONES DE ACCIÓN
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // BOTÓN EDITAR
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
                );
              },
            ),
            // BOTÓN ELIMINAR
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () {
                _confirmDelete(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Eliminar Tarea"),
        content: Text("¿Estás seguro de que deseas eliminar '${task.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              // Llamamos al Bloc para eliminar
              context.read<TaskBloc>().deleteTask(task.id, task.projectId);
              Navigator.pop(dialogContext);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
