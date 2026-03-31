import 'package:todo_app/domain/repositories/task_repository.dart';

class DeleteTask {
  final TaskRepository repository;

  DeleteTask(this.repository);

  Future<void> call({required int id}) {
    return repository.deleteTask(id);
  }
}
