import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/task_repository_impl.dart';
import 'presentation/blocs/task_bloc.dart';

import 'presentation/pages/project_page.dart';
import 'presentation/pages/all_projects_page.dart';
import 'presentation/pages/all_users_page.dart';
import 'presentation/pages/all_tasks_page.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc(TaskRepositoryImpl()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        initialRoute: "/",

        routes: {
          "/": (_) => const ProjectsPage(),
          "/projects": (_) => const AllProjectsPage(),
          "/users": (_) => const AllUsersPage(),
          "/tasks": (_) => const AllTasksPage(),
          //"/deleted": (_) => const AllTasksPage(showDeleted: true),
        },
      ),
    );
  }
}
