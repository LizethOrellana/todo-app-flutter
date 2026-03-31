import '../../domain/entities/task.dart';

class TaskState {
  final List<Task> tasks;
  final bool loading;
  final String? error;

  TaskState({required this.tasks, required this.loading, this.error});

  factory TaskState.initial() {
    return TaskState(tasks: [], loading: false);
  }

  TaskState copyWith({List<Task>? tasks, bool? loading, String? error}) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
