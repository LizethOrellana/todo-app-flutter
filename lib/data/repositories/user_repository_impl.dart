import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart'; // 👈 importa la entity

class UserRepositoryImpl {
  final String baseUrl = "http://localhost:5205/api/users";

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar usuarios");
    }
  }

  Future<User> addUser(String name, String email) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name, "email": email}),
    );
    final json = jsonDecode(response.body);
    return User.fromJson(json);
  }
}
