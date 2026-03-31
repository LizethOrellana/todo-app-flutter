import 'package:flutter/material.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  final repo = UserRepositoryImpl();
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final data = await repo.getUsers();
    setState(() => users = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuarios")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) {
          final u = users[i];
          return ListTile(
            title: Text(u.name),
            subtitle: Text(u.email ?? ""),
            leading: const Icon(Icons.person),
          );
        },
      ),
    );
  }
}
