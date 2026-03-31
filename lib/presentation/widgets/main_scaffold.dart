import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? floatingActionButton;

  const MainScaffold({
    super.key,
    required this.title,
    required this.child,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),

      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF235347),
        foregroundColor: Colors.white,
      ),

      // 🔥 MENÚ MEJORADO
      drawer: Drawer(
        child: Column(
          children: [
            // 🔹 HEADER
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF235347)),
              accountName: Text("KanbanFlow"),
              accountEmail: Text("Gestión de tareas"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.task, color: Color(0xFF235347)),
              ),
            ),

            // 🔹 OPCIONES
            _menuItem(
              context,
              icon: Icons.folder,
              title: "Proyectos",
              route: "/projects",
            ),

            _menuItem(
              context,
              icon: Icons.person,
              title: "Usuarios",
              route: "/users",
            ),

            _menuItem(
              context,
              icon: Icons.list_alt,
              title: "Todas las tareas",
              route: "/tasks",
            ),

            const Divider(),

            _menuItem(
              context,
              icon: Icons.delete,
              title: "Tareas eliminadas",
              route: "/deleted",
              color: Colors.red,
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.all(12),
              child: Text("v1.0", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),

      body: Padding(padding: const EdgeInsets.all(12), child: child),

      floatingActionButton: floatingActionButton,
    );
  }

  // 🔥 WIDGET REUTILIZABLE
  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF235347)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // cierra drawer
        Navigator.pushNamed(context, route);
      },
    );
  }
}
