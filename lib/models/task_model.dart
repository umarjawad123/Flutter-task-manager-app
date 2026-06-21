class TaskModel {
  String title;
  String description;
  bool isDone;

  TaskModel({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "isDone": isDone,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      isDone: json["isDone"] ?? false,
    );
  }
}