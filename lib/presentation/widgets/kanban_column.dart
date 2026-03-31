import 'package:flutter/material.dart';
import '../../domain/entities/task.dart';
import 'task_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final String status;
  final List<Task> tasks;
  final Function(Task, String) onDrop;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.status,
    required this.tasks,
    required this.onDrop,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DragTarget<Task>(
        onAccept: (task) {
          onDrop(task, status); // 🔥 CAMBIO DE ESTADO
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: candidateData.isNotEmpty
                  ? Colors.green[100]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...tasks.map((t) => TaskCard(task: t)),
              ],
            ),
          );
        },
      ),
    );
  }
}
