class TodoModel {
  TodoModel({this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
  });

  final String? id;
  final String title;
  static const String titleKey = "title";

  final String description;
  static const String descriptionKey = "description";

  final String date;
  static const String dateKey = "date";

  final String status;
  static const String statusKey = "status";


  factory TodoModel.fromJson(dynamic json){
    return TodoModel(
      id: json.id ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      date: json["date"] ?? "",
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "date": date,
    "status": status,
  };

}
