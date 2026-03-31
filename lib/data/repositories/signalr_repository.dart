import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection _connection;

  Future<void> connect() async {
    _connection = HubConnectionBuilder()
        .withUrl("http://localhost:5205/taskHub")
        .build();

    await _connection.start();
    print(" Conectado a SignalR");
  }

  // LISTENERS

  void onTaskCreated(Function(dynamic) callback) {
    _connection.on("taskCreated", (args) {
      callback(args![0]);
    });
  }

  void onTaskUpdated(Function(dynamic) callback) {
    _connection.on("taskUpdated", (args) {
      callback(args![0]);
    });
  }

  void onTaskDeleted(Function(dynamic) callback) {
    _connection.on("taskDeleted", (args) {
      callback(args![0]);
    });
  }

  Future<void> disconnect() async {
    await _connection.stop();
  }
}
