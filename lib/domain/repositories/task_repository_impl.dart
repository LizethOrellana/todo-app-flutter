import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(String title, String description);
  Future<Task> updateTask(Task task);
  Future<Task> completeTask(int id);
  Future<void> deleteTask(int id);
}
