import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(
    String title,
    String description,
    int projectId,
    int? userId,
  );
  Future<Task> updateTask(Task task);
  Future<Task> completeTask(int id);
  Future<void> deleteTask(int id);
  Future<List<Task>> getDeletedTasks();
  Future<List<Task>> searchTasks(String query);
  Future<List<Task>> getTasksByProject(int projectId);
}
