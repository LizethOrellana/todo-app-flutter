import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future call(String title, String description, int projectId, int? userId) {
    return repository.addTask(title, description, projectId, userId);
  }
}
