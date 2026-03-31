import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/repositories/signalr_repository.dart';
import 'package:todo_app/domain/usecases/add_task.dart';
import 'package:todo_app/domain/usecases/delete_task.dart';
import 'package:todo_app/domain/usecases/get_deleted_tasks.dart';
import 'package:todo_app/domain/usecases/get_tasks.dart';
import 'package:todo_app/domain/usecases/update_task.dart';
import '../../data/repositories/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import 'task_state.dart';

class TaskBloc extends Cubit<TaskState> {
  final GetTasks getTasks;
  final AddTask addTaskUC;
  final DeleteTask deleteTaskUC;
  final UpdateTask updateTaskUC;
  final GetDeletedTasks getDeletedTasksUC;
  final SignalRService _signalR = SignalRService();

  TaskBloc(TaskRepositoryImpl repo)
    : getTasks = GetTasks(repo),
      addTaskUC = AddTask(repo),
      deleteTaskUC = DeleteTask(repo),
      updateTaskUC = UpdateTask(repo),
      getDeletedTasksUC = GetDeletedTasks(repo),
      super(TaskState.initial());

  Future<void> loadTasks(int projectId) async {
    emit(state.copyWith(loading: true));

    try {
      final tasks = await getTasks(projectId);
      emit(state.copyWith(tasks: tasks, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> addTask(
    String title,
    String desc,
    int projectId, {
    int? userId,
  }) async {
    await addTaskUC(title, desc, projectId, userId);
    await loadTasks(projectId);
  }

  Future<void> deleteTask(int id, int projectId) async {
    await deleteTaskUC(id: id);
    await loadTasks(projectId);
  }

  Future<void> updateStatus(Task task, String status, int projectId) async {
    final updated = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: status,
      projectId: task.projectId,
      userId: task.userId,
    );

    await updateTaskUC(updated);
    await loadTasks(projectId);
  }

  Future<void> loadDeletedTasks() async {
    emit(state.copyWith(loading: true));

    try {
      final tasks = await getDeletedTasksUC();

      emit(state.copyWith(tasks: tasks, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
