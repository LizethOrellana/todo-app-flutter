import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/task.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_state.dart';
import 'edit_task_page.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({super.key});

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  String search = "";
  bool showDeleted = false;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().loadTasks(1); // puedes cambiar projectId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todas las Tareas"),
        actions: [
          IconButton(
            icon: Icon(showDeleted ? Icons.visibility_off : Icons.delete),
            onPressed: () {
              setState(() => showDeleted = !showDeleted);

              if (showDeleted) {
                context.read<TaskBloc>().loadDeletedTasks();
              } else {
                context.read<TaskBloc>().loadTasks(1);
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Buscar tarea...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),

          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (_, state) {
                final tasks = state.tasks.where((t) {
                  return t.title.toLowerCase().contains(search.toLowerCase()) ||
                      (t.description ?? "").toLowerCase().contains(
                        search.toLowerCase(),
                      );
                }).toList();

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (_, i) {
                    final t = tasks[i];

                    return Card(
                      child: ListTile(
                        title: Text(t.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.description ?? ""),
                            Text("Estado: ${t.status}"),
                            Text("Proyecto: ${t.projectId}"),
                            Text("Usuario: ${t.userId ?? 'N/A'}"),
                          ],
                        ),

                        trailing: showDeleted
                            ? IconButton(
                                icon: const Icon(Icons.restore),
                                onPressed: () {
                                  context.read<TaskBloc>().updateStatus(
                                    t,
                                    "Pending",
                                    t.projectId,
                                  );
                                },
                              )
                            : PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "edit") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditTaskPage(task: t),
                                      ),
                                    );
                                  } else if (value == "delete") {
                                    context.read<TaskBloc>().deleteTask(
                                      t.id,
                                      t.projectId,
                                    );
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Text("Editar"),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Text("Eliminar"),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
