class Task {
  final int id;
  final String title;
  final String? description;
  final String status;
  final int projectId;
  final int? userId;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.projectId,
    this.userId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'Pending',
      projectId: json['projectId'] ?? 0,
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "status": status,
      "projectId": projectId,
      "userId": userId,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    int? projectId,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      projectId: projectId ?? this.projectId,
      userId: userId ?? this.userId,
    );
  }
}
