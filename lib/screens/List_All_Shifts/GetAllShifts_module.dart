class ShiftModel {
  final String id;
  final String userName;

  final String day;

  ShiftModel({
    required this.id,
    required this.userName,
    required this.day,
  });
  

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['_id'],
      userName: json['userId']['name'],
      day: json['day'],
    );
  }
  // This is the fromJsonList method which parses a list of JSON objects.
  static List<ShiftModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => ShiftModel.fromJson(item)).toList();
  }
}
