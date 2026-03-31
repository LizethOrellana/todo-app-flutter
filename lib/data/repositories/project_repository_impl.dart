import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/domain/entities/project.dart';

class ProjectRepositoryImpl {
  final String baseUrl = "http://localhost:5205/api/projects";

  Future<List<Project>> getProjects() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Project.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar proyectos");
    }
  }

  Future<Project> addProject(String name) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name}),
    );
    final json = jsonDecode(response.body);
    return Project.fromJson(json);
  }
}
