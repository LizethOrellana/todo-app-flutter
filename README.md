#  Task Management Mobile App

##  Descripción

Aplicación móvil desarrollada en Flutter para la gestión de tareas tipo Kanban.  
Permite visualizar, crear, actualizar y organizar tareas por proyecto en tiempo real.

Esta aplicación consume una API desarrollada en ASP.NET Core.

---

##  Tecnologías

- Flutter
- Dart
- HTTP
- SignalR (tiempo real)
- Bloc (gestión de estado)

---

##  Funcionalidades

- Listado de proyectos
- Creación de tareas
- Edición de tareas
- Asignación de usuarios
- Visualización tipo Kanban
- Cambio de estado (drag & drop)
- Sincronización en tiempo real
- Soft delete de tareas
- Restauración de tareas

---

##  Flujo de la aplicación

- Selección de proyecto
- Visualización de tareas por estado
- Creación y edición de tareas
- Actualización automática mediante SignalR

---

##  Integración

La aplicación se conecta a una API REST para la gestión de datos:

 Backend: ASP.NET Core API  
 Comunicación: HTTP + SignalR

---

##  Arquitectura

Se implementó una estructura basada en separación de responsabilidades:

- Presentation → UI (Pages, Widgets)
- State Management → Bloc
- Domain → entidades
- Data → repositorios y servicios HTTP

---

##  Estructura

lib/

├── data/

├── domain/

├── presentation/

├── blocs/

├── pages/

├── widgets/



---

## ▶ Ejecución

```bash
flutter pub get
flutter run
Backend: 'https://github.com/LizethOrellana/TodoApp.Api'
