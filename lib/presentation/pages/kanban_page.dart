import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/main_scaffold.dart';
import '../pages/create_tasks_page.dart';
import '../widgets/kanban_column.dart';

import '../../domain/entities/task.dart';
import '../blocs/task_bloc.dart';
import '../blocs/task_state.dart';

class KanbanPage extends StatefulWidget {
  final int projectId;
  final String projectName;

  const KanbanPage({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<KanbanPage> createState() => _KanbanPageState();
}

class _KanbanPageState extends State<KanbanPage> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().loadTasks(widget.projectId);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: widget.projectName,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateTaskPage(projectId: widget.projectId),
            ),
          );

          context.read<TaskBloc>().loadTasks(widget.projectId);
        },
        child: const Icon(Icons.add),
      ),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (_, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final pending = state.tasks
              .where((t) => t.status == "Pending")
              .toList();

          final inProcess = state.tasks
              .where((t) => t.status == "InProcess")
              .toList();

          final done = state.tasks.where((t) => t.status == "Done").toList();

          return Row(
            children: [
              KanbanColumn(
                title: "Pendiente",
                status: "Pending",
                tasks: pending,
                onDrop: _onDrop,
              ),
              KanbanColumn(
                title: "En Proceso",
                status: "InProcess",
                tasks: inProcess,
                onDrop: _onDrop,
              ),
              KanbanColumn(
                title: "Finalizado",
                status: "Done",
                tasks: done,
                onDrop: _onDrop,
              ),
            ],
          );
        },
      ),
    );
  }

  void _handleAction(Task task, String action) {
    if (action == "delete") {
      context.read<TaskBloc>().deleteTask(task.id, widget.projectId);
    } else {
      context.read<TaskBloc>().updateStatus(task, action, widget.projectId);
    }
  }

  void _onDrop(Task task, String newStatus) {
    if (task.status == newStatus) return;

    final updated = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: newStatus,
      projectId: task.projectId,
      userId: task.userId,
    );

    context.read<TaskBloc>().updateStatus(updated, newStatus, widget.projectId);
  }
}
