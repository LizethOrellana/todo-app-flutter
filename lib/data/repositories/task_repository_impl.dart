import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  final String baseUrl = "http://localhost:5205/api/tasks";

  @override
  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Task.fromJson(json)).toList();
  }

  @override
  Future<Task> addTask(
    String title,
    String description,
    int projectId,
    int? userId,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "status": "Pending",
        "projectId": projectId,
        "userId": userId,
      }),
    );
    final json = jsonDecode(response.body);
    return Task.fromJson(json);
  }

  @override
  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${task.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(task.toJson()),
    );
    final json = jsonDecode(response.body);
    return Task.fromJson(json);
  }

  @override
  Future<Task> completeTask(int id) async {
    final response = await http.put(Uri.parse("$baseUrl/$id/complete"));
    final json = jsonDecode(response.body);
    return Task.fromJson(json);
  }

  @override
  Future<void> deleteTask(int id) async {
    await http.delete(Uri.parse("$baseUrl/$id"));
  }

  Future<List<Task>> getDeletedTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/deleted'));
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Task.fromJson(json)).toList();
  }

  Future<List<Task>> searchTasks(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search?query=$query'));
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Task.fromJson(json)).toList();
  }

  Future<List<Task>> getTasksByProject(int projectId) async {
    final response = await http.get(
      Uri.parse("http://localhost:5205/api/projects/$projectId/tasks"),
    );
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Task.fromJson(json)).toList();
  }
}
