import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetDeletedTasks {
  final TaskRepository repository;

  GetDeletedTasks(this.repository);

  Future<List<Task>> call() {
    return repository.getDeletedTasks();
  }
}
